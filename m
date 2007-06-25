Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:45254 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752781AbXFYP2C (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jun 2007 11:28:02 -0400
Subject: Re: airo
From: Dan Williams <dcbw@redhat.com>
To: Michal Schmidt <mschmidt@redhat.com>
Cc: Matteo Croce <rootkit85@yahoo.it>, linux-wireless@vger.kernel.org
In-Reply-To: <467FD362.8000602@redhat.com>
References: <200706061903.13228.rootkit85@yahoo.it>
	 <46693003.8090406@redhat.com> <200706091519.29319.rootkit85@yahoo.it>
	 <200706091816.47618.rootkit85@yahoo.it>  <467FD362.8000602@redhat.com>
Content-Type: text/plain
Date: Mon, 25 Jun 2007 11:05:39 -0400
Message-Id: <1182783939.5449.1.camel@xo-13-A4-25.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2007-06-25 at 16:38 +0200, Michal Schmidt wrote:
> Matteo Croce wrote:
> > after booting i have this situation:
> >
> > root@raver:~# lsmod |fgrep airo
> > airo                   80016  0
> > root@raver:~# dmesg |fgrep airo
> > airo(): Probing for PCI adapters
> > airo(eth1): cmd:111 status:7f11 rsp0:2 rsp1:0 rsp2:0
> > airo(eth1): Doing fast bap_reads
> > airo(eth1): WPA is supported.
> > airo(eth1): Couldn't register_netdev
> > airo(): Finished probing for PCI adapters
> > root@raver:~#
> >
> > I have to do this to connect:
> >
> > root@raver:~# rmmod airo
> > root@raver:~# modprobe airo
> > root@raver:~# dmesg |fgrep airo
> > airo(): Probing for PCI adapters
> > airo(eth1): cmd:111 status:7f11 rsp0:2 rsp1:0 rsp2:0
> > airo(eth1): Doing fast bap_reads
> > airo(eth1): WPA is supported.
> > airo(eth1): Couldn't register_netdev
> > airo(): Finished probing for PCI adapters
> > airo(): Probing for PCI adapters
> > airo(eth0): cmd:111 status:7f11 rsp0:2 rsp1:0 rsp2:0
> > airo(eth0): Doing fast bap_reads
> > airo(eth0): WPA is supported.
> > airo(eth0): MAC enabled 0:d:29:4f:c:be
> > airo(): Finished probing for PCI adapters
> > root@raver:~#
> >   
> 
> Hi Matteo,
> 
> It looks like some other network interface gets renamed from "eth0" to
> "eth1" at the same time the airo driver is initializing the card. Does
> it happen always after booting? Do you have other network interfaces?
> This patch should fix it. Can you test it?

Wow, that's somewhat ugly.  Do other drivers just not have this problem,
or have they worked around it in similar or different ways?  Just trying
to understand if the scope of the issue is wider than just airo.

Dan

> Michal
> 
> diff --git a/drivers/net/wireless/airo.c b/drivers/net/wireless/airo.c
> index 2d3a180..1a350b3 100644
> --- a/drivers/net/wireless/airo.c
> +++ b/drivers/net/wireless/airo.c
> @@ -41,6 +41,7 @@
>  
>  #include <linux/netdevice.h>
>  #include <linux/etherdevice.h>
> +#include <linux/rtnetlink.h>
>  #include <linux/skbuff.h>
>  #include <linux/if_arp.h>
>  #include <linux/ioport.h>
> @@ -2802,10 +2803,6 @@ static struct net_device *_init_airo_card( unsigned short irq, int port,
>  		airo_print_err("", "Couldn't alloc_etherdev");
>  		return NULL;
>          }
> -	if (dev_alloc_name(dev, dev->name) < 0) {
> -		airo_print_err("", "Couldn't get name!");
> -		goto err_out_free;
> -	}
>  
>  	ai = dev->priv;
>  	ai->wifidev = NULL;
> @@ -2813,7 +2810,7 @@ static struct net_device *_init_airo_card( unsigned short irq, int port,
>  	ai->jobs = 0;
>  	ai->dev = dev;
>  	if (pci && (pci->device == 0x5000 || pci->device == 0xa504)) {
> -		airo_print_dbg(dev->name, "Found an MPI350 card");
> +		airo_print_dbg("", "Found an MPI350 card");
>  		set_bit(FLAG_MPI, &ai->flags);
>  	}
>  	spin_lock_init(&ai->aux_lock);
> @@ -2821,14 +2818,11 @@ static struct net_device *_init_airo_card( unsigned short irq, int port,
>  	ai->config.len = 0;
>  	ai->pci = pci;
>  	init_waitqueue_head (&ai->thr_wait);
> -	ai->airo_thread_task = kthread_run(airo_thread, dev, dev->name);
> -	if (IS_ERR(ai->airo_thread_task))
> -		goto err_out_free;
>  	ai->tfm = NULL;
>  	add_airo_dev(ai);
>  
>  	if (airo_networks_allocate (ai))
> -		goto err_out_thr;
> +		goto err_out_free;
>  	airo_networks_initialize (ai);
>  
>  	/* The Airo-specific entries in the device structure. */
> @@ -2855,16 +2849,31 @@ static struct net_device *_init_airo_card( unsigned short irq, int port,
>  	reset_card (dev, 1);
>  	msleep(400);
>  
> +	rtnl_lock();  /* Makes sure no device registers our name. */
> +	if (dev_alloc_name(dev, dev->name) < 0) {
> +		airo_print_err("", "Couldn't get name!");
> +		rtnl_unlock();
> +		goto err_out_nets;
> +	}
> +
> +	ai->airo_thread_task = kthread_run(airo_thread, dev, dev->name);
> +	if (IS_ERR(ai->airo_thread_task)) {
> +		rtnl_unlock();
> +		goto err_out_nets;
> +	}
> +
>  	rc = request_irq( dev->irq, airo_interrupt, IRQF_SHARED, dev->name, dev );
>  	if (rc) {
>  		airo_print_err(dev->name, "register interrupt %d failed, rc %d",
>  				irq, rc);
> -		goto err_out_nets;
> +		rtnl_unlock();
> +		goto err_out_thr;
>  	}
>  	if (!is_pcmcia) {
>  		if (!request_region( dev->base_addr, 64, dev->name )) {
>  			rc = -EBUSY;
>  			airo_print_err(dev->name, "Couldn't request region");
> +			rtnl_unlock();
>  			goto err_out_irq;
>  		}
>  	}
> @@ -2872,6 +2881,7 @@ static struct net_device *_init_airo_card( unsigned short irq, int port,
>  	if (test_bit(FLAG_MPI,&ai->flags)) {
>  		if (mpi_map_card(ai, pci, dev->name)) {
>  			airo_print_err(dev->name, "Could not map memory");
> +			rtnl_unlock();
>  			goto err_out_res;
>  		}
>  	}
> @@ -2880,6 +2890,7 @@ static struct net_device *_init_airo_card( unsigned short irq, int port,
>  		if ( setup_card( ai, dev->dev_addr, 1 ) != SUCCESS ) {
>  			airo_print_err(dev->name, "MAC could not be enabled" );
>  			rc = -EIO;
> +			rtnl_unlock();
>  			goto err_out_map;
>  		}
>  	} else if (!test_bit(FLAG_MPI,&ai->flags)) {
> @@ -2899,9 +2910,10 @@ static struct net_device *_init_airo_card( unsigned short irq, int port,
>  		ai->bssListRidLen = sizeof(BSSListRid) - sizeof(BSSListRidExtra);
>  	}
>  
> -	rc = register_netdev(dev);
> +	rc = register_netdevice(dev);
> +	rtnl_unlock();
>  	if (rc) {
> -		airo_print_err(dev->name, "Couldn't register_netdev");
> +		airo_print_err(dev->name, "Couldn't register_netdevice");
>  		goto err_out_map;
>  	}
>  	ai->wifidev = init_wifidev(ai, dev);
> @@ -2942,13 +2954,13 @@ err_out_res:
>  	        release_region( dev->base_addr, 64 );
>  err_out_irq:
>  	free_irq(dev->irq, dev);
> -err_out_nets:
> -	airo_networks_free(ai);
>  err_out_thr:
> -	del_airo_dev(ai);
>  	set_bit(JOB_DIE, &ai->jobs);
>  	kthread_stop(ai->airo_thread_task);
> +err_out_nets:
> +	airo_networks_free(ai);
>  err_out_free:
> +	del_airo_dev(ai);
>  	free_netdev(dev);
>  	return NULL;
>  }
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


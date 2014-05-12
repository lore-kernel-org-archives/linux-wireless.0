Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f176.google.com ([209.85.214.176]:36546 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758227AbaELO60 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 May 2014 10:58:26 -0400
Received: by mail-ob0-f176.google.com with SMTP id wo20so8130793obc.7
        for <linux-wireless@vger.kernel.org>; Mon, 12 May 2014 07:58:26 -0700 (PDT)
Message-ID: <5370E189.4050702@lwfinger.net> (sfid-20140512_165830_561582_4AE583FD)
Date: Mon, 12 May 2014 09:58:17 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
CC: Timber Deng <fengjingchao@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Kernel binary for RTL8192EE
References: <536FA82C.1040203@lwfinger.net>	<CAB1v6G2jEgcUrCsQn2mo5Zts2mXpVfYTmjkg_dMT2oAQKOc08w@mail.gmail.com> <CAB1v6G0iFqjaLcmsFS=H_5d+Shr13-wJww74jP=adi01mLmZdw@mail.gmail.com>
In-Reply-To: <CAB1v6G0iFqjaLcmsFS=H_5d+Shr13-wJww74jP=adi01mLmZdw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/12/2014 09:11 AM, Timber Deng wrote:
> Hi Larry,
>
> Failed to sent to "linux-wireless@vger.kernelorg
> <mailto:linux-wireless@vger.kernel.org>" in previous try... In case you didn't
> receive message, it's below.
>
> BTW, if I wanna fix the bug myself, how can I find some guide for kernel
> function documentation, debugging? Let me know.
>
> Thanks!
>
> /--/
> /Hongchao Deng (Timber)/
> /Carnegie Mellon University
> /
> /hongchad@andrew.cmu.edu <mailto:hongchad@andrew.cmu.edu>/
>
>
> On Mon, May 12, 2014 at 10:07 AM, Timber Deng <fengjingchao@gmail.com
> <mailto:fengjingchao@gmail.com>> wrote:
>
>     Hi Larry,
>
>     I am reporting an error in current RTL8192EE driver. This error happened
>     both in the 3.13.9 kernel you sent earlier or custom 3.14 built with patches
>     in
>     (http://www.lwfinger.com/__realtek_drivers/0001-staging-__r8192ee-Add-new-driver.patch
>     <http://www.lwfinger.com/realtek_drivers/0001-staging-r8192ee-Add-new-driver.patch>
>     ​, ​
>     http://www.lwfinger.com/__realtek_drivers/0002-staging-__r8192ee-Add-new-driver.patch
>     <http://www.lwfinger.com/realtek_drivers/0002-staging-r8192ee-Add-new-driver.patch>
>     ​​). Ubuntu 14.04.
>     ​
>
>     After using the wifi for a relatively long time and viewing large traffic
>     (e.g. video streaming), the OS is stuck and no actions can be made.
>     ​
>     The kernel log​ (/var/log/kern.log) shows that repeatedly:
>     ===
>     ...
>     May 12 08:13:44 feng-T440s kernel: [39766.630856] skb->end - skb->tail =
>     16000, len is 16174
>     May 12 08:13:44 feng-T440s kernel: [39766.635128] skb->end - skb->tail =
>     16000, len is 16174
>     May 12 08:13:44 feng-T440s kernel: [39766.733385] skb->end - skb->tail =
>     16000, len is 16174
>     ...
>     ===
>
>     I looked at the patch code, it's here:
>     ===
>
>     len = rtlpriv->cfg->ops->get_desc((u8 *)pdesc, false,
>     +						  HW_DESC_RXPKT_LEN);
>
>     	        if (skb->end - skb->tail > len) {
>     +			skb_put(skb, len);
>     +			if (rtlpriv->use_new_trx_flow)
>     +				skb_reserve(skb, status.rx_drvinfo_size +
>     +						 status.rx_bufshift + 24);
>     +			else
>     +				skb_reserve(skb, status.rx_drvinfo_size +
>     +						 status.rx_bufshift);
>     +
>     +		} else {
>     +			printk("skb->end - skb->tail = %d, len is %d\n",
>     +			       skb->end - skb->tail, len);
>     +			break;
>     +		}
>     +
>
>     ===
>
>     It seems like the wireless is constantly receiving packet larger than socket buffer and dropping it.
>
>     What's worse, it doesn't stop this behavior in a reasonable way but continuously consuming all CPU resources.
>
>
>     Please fix it ASAP.
>     Thanks!
>
>     /--/
>     /Hongchao Deng (Timber)/
>     /Carnegie Mellon University
>     /
>     /hongchad@andrew.cmu.edu <mailto:hongchad@andrew.cmu.edu>/
>
>
>     On Sun, May 11, 2014 at 12:41 PM, Larry Finger <Larry.Finger@lwfinger.net
>     <mailto:Larry.Finger@lwfinger.net>> wrote:
>
>         This mail is blind copied to everyone that has contacted me regarding a
>         driver for the RTL8192EE, and to the Realtek developers.
>
>         Although the patches needed to add this driver to the 3.14.X kernel were
>         made available earlier, not everyone has the expertise needed to build a
>         kernel for their system. As the Lenovo T440s is the only computer that
>         currently is shipping with this device, and Lenovo uses Ubuntu 14.04, I
>         have built such a patched kernel and I am making is available. This one
>         uses the official 3.13.3 source currently in use by Ubuntu and includes
>         all of their patches.
>
>         The file is obtained at
>         http://www.lwfinger.com/__realtek_drivers/linux-image-3.__13.9_0.9_amd64.deb
>         <http://www.lwfinger.com/realtek_drivers/linux-image-3.13.9_0.9_amd64.deb>.
>         At present, I do not have a 32-bit version available. After downloading,
>         this kernel is installed using the command 'sudo dpkg -i
>         <path_to_downloaded_deb_file>

You have a typo in the linux-wireless address. It is kernel.org, not kernelorg.

The first place to look for debugging help in in the Documentation directory in 
the sources. I have seen the same printout with my version in the main wireless 
tree, but I have not seen it with the staging version. It is not reasonable for 
the packet length to be that that long. The apparent packet length comes from 
reading the copy of the RX descriptor passed in the skb. The low 14 bits in the 
first word should contain that quantity. I do not know if the problem is in the 
firmware or the driver code.

Sometime in the next couple of days, I will post revised patches and a new deb 
file that handles the problem more intelligently. Unfortunately, I do not have a 
fix.

On Linux mailing lists, please refrain from top posting. If you bottom post as I 
did here, a reader can see whatever history the writer wants to show without 
scrolling down and back up. The standard joke is

A. Because it is not in natural order.

Q. Why is top posting bad?

Larry




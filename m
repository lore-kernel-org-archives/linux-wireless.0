Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:42310 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753892AbXJ3POw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Oct 2007 11:14:52 -0400
Subject: Re: [ath5k-devel] MadWifi HAL register dumps - help reverse
	engineering
From: Dan Williams <dcbw@redhat.com>
To: bruno randolf <bruno@thinktube.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	ath5k-devel@lists.ath5k.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	madwifi-devel <madwifi-devel@lists.sourceforge.net>
In-Reply-To: <200710301749.32236.bruno@thinktube.com>
References: <43e72e890710191255k72c7176fx10592dcfc02cb287@mail.gmail.com>
	 <200710301749.32236.bruno@thinktube.com>
Content-Type: text/plain
Date: Tue, 30 Oct 2007 11:12:49 -0400
Message-Id: <1193757169.29187.19.camel@localhost.localdomain> (sfid-20071030_151456_322722_BA7785C5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2007-10-30 at 17:49 +0900, bruno randolf wrote:
> hi luis!
> 
> adding the following patch lets us log the calling function names as well! 
> which makes it much easier to make sense to the traces :)
> 
> and i added ALQ=1 MMIOTRACE=1 and the objdump command to the Makefile as well 
> to avoid forgetting that.
> 
> cheers,
> bruno
> 
> this time the patch is included, sorry...
> 
> diff -Nurb madwifi-trace.luis/ath_hal/ah_os.c madwifi-trace/ath_hal/ah_os.c
> --- madwifi-trace.luis/ath_hal/ah_os.c	2007-10-30 17:44:48.000000000 +0900
> +++ madwifi-trace/ath_hal/ah_os.c	2007-10-30 17:39:52.000000000 +0900
> @@ -152,6 +152,7 @@
>   * useful for debugging and figuring out, which hal function sets which 
>   * registers */
>  char *ath_hal_func = NULL;
> +EXPORT_SYMBOL(ath_hal_func);

Any particular reason this is not EXPORT_SYMBOL_GPL?

>  #endif
>  
>  #ifdef AH_DEBUG_ALQ
> diff -Nurb madwifi-trace.luis/ath_hal/ah_os.h madwifi-trace/ath_hal/ah_os.h
> --- madwifi-trace.luis/ath_hal/ah_os.h	2007-10-30 17:44:28.000000000 +0900
> +++ madwifi-trace/ath_hal/ah_os.h	2007-10-30 17:39:52.000000000 +0900
> @@ -228,13 +228,9 @@
>  
>  extern char *ath_hal_func;
>  static inline void ath_hal_set_function(const char *name)
> -#if defined(AH_DEBUG)
>  {
>  	ath_hal_func = (char *)name;
>  }
> -#else
> -{ }
> -#endif
>  
>  #ifdef AH_DEBUG_ALQ
>  extern	void __ahdecl OS_MARK(struct ath_hal *, u_int id, u_int32_t value);
> diff -Nurb madwifi-trace.luis/Makefile madwifi-trace/Makefile
> --- madwifi-trace.luis/Makefile	2007-10-30 17:44:55.000000000 +0900
> +++ madwifi-trace/Makefile	2007-10-30 17:39:52.000000000 +0900
> @@ -50,7 +50,7 @@
>  include $(TOP)/Makefile.inc
>  endif
>  
> -DIRS_MODULES = $(ATH) $(ATH_HAL) $(ATH_RATE) $(WLAN) $(if 
> $(MMIOTRACE),mmiotrace/)
> +DIRS_MODULES = $(ATH) $(ATH_HAL) $(ATH_RATE) $(WLAN) mmiotrace/
>  
>  obj-y := ath/ ath_hal/ ath_rate/ net80211/ $(if $(MMIOTRACE),mmiotrace/)
>  
> @@ -62,7 +62,12 @@
>  		$(MAKE) -C $$i || exit 1; \
>  	done
>  else
> -	$(MAKE) -C $(KERNELPATH) SUBDIRS=$(shell pwd) modules
> +	$(MAKE) -C $(KERNELPATH) SUBDIRS=$(shell pwd) ALQ=1 MMIOTRACE=1 modules
> +	cp ath/ath_pci.ko ath/ath_pci.ko.old; \
> +	objcopy --redefine-sym __ioremap=__ioremap_trace \
> +		--redefine-sym iounmap=iounmap_trace \
> +		--redefine-sym ioremap_nocache=ioremap_nocache_trace \
> +		ath/ath_pci.ko.old ath/ath_pci.ko
>  endif
>  
>  .PHONY: svnversion.h
> @@ -91,7 +96,7 @@
>  	sh scripts/find-madwifi-modules.sh -r $(KERNELRELEASE) $(DESTDIR)
>  
>  	for i in $(DIRS_MODULES); do \
> -		$(MAKE) -C $$i install || exit 1; \
> +		$(MAKE) -C $$i ALQ=1 MMIOTRACE=1 install || exit 1; \
>  	done
>  ifeq ($(DESTDIR),)
>  	(export KMODPATH=$(KMODPATH); /sbin/depmod -ae $(KERNELRELEASE))
> diff -Nurb madwifi-trace.luis/mmiotrace/Makefile 
> madwifi-trace/mmiotrace/Makefile
> --- madwifi-trace.luis/mmiotrace/Makefile	2007-10-30 17:44:55.000000000 +0900
> +++ madwifi-trace/mmiotrace/Makefile	2007-10-30 17:41:42.000000000 +0900
> @@ -13,3 +13,8 @@
>  install:
>  	test -d $(DESTDIR)/$(KMODPATH) || mkdir -p $(DESTDIR)/$(KMODPATH)
>  	install mmio.$(KMODSUF) $(DESTDIR)/$(KMODPATH)
> +
> +clean:
> +	rm -f *~ *.o *.ko *.mod.c .*.cmd
> +	rm -f .depend .version .*.o.flags .*.o.d
> +	rm -rf .tmp_versions
> 
> On Saturday 20 October 2007 04:55:18 Luis R. Rodriguez wrote:
> > We have initial support for AR5210s (still needs work), AR5211 and
> > AR5212. To add support for other hardware we'll need register dumps of
> > the HAL. Fortunately we have a way to do this. It's still hard to
> > figure out what we're supposed to do but at least we can get the some
> > idea of what to do this way.
> >
> > Below are instructions, you can find later instructions on the URL:
> >
> > http://kernel.org/pub/linux/kernel/people/mcgrof/madwifi-regdumps/README
> >
> > MadWifi HAL Register dumping
> > ----------------------------
> >
> > You can use these instructions to get register dumps of HAL register
> > reads and writes. For this we build the alq and mmio trap modules and
> > make some use of them.
> >
> > This is based on patches and information from:
> >
> > http://madwifi.org/ticket/1380
> > http://nouveau.freedesktop.org/wiki/MmioTrace
> >
> > -- Steps to take ---
> >
> > 0. Get MadWifi svn trunk, patches, pach up and build:
> >
> > svn export http://svn.madwifi.org/madwifi/trunk trunk
> > wget
> > http://kernel.org/pub/linux/kernel/people/mcgrof/madwifi-regdumps/alq.diff
> > wget
> > http://kernel.org/pub/linux/kernel/people/mcgrof/madwifi-regdumps/mmio.diff
> > wget
> > http://kernel.org/pub/linux/kernel/people/mcgrof/madwifi-regdumps/var.diff
> >
> > cd trunk/
> > patch -p1 < ../alq.patch
> > patch -p1 < ../mmio.patch
> > patch -p1 < ../var.diff
> >
> > make ALQ=1 MMIOTRACE=1
> >
> > 1. Alter the ath_pci.ko module with this command and then install modules:
> >
> > mv ath/ath_pci.ko ath/ath_pci.ko.old
> > objcopy --redefine-sym __ioremap=__ioremap_trace --redefine-sym \
> > 	iounmap=iounmap_trace --redefine-sym  \
> > 	ioremap_nocache=ioremap_nocache_trace \
> > 	ath/ath_pci.ko.old ath/ath_pci.ko
> >
> > sudo make install ALQ=1 MMIOTRACE=1
> >
> > 2. Load mmio, alq, ath_hal
> >
> > sudo modprobe mmio
> > sudo modprobe alq
> > sudo modprobe ath_hal
> >
> > 3. Proc stuff:
> >
> > sudo su -
> > echo 2 > /proc/sys/dev/ath/hal/debug
> > echo 1 > /proc/sys/dev/ath/hal/alq
> >
> > 4. Load ath_pci
> >
> > modprobe ath_pci
> >
> > 5. Check reg dump file exists
> >
> > ls -l /tmp/ath_hal.log
> >
> > As you do things with the driver it should increase in size:
> >
> > root@pogo:~# wc -l /tmp/ath_hal.log
> > 14236 /tmp/ath_hal.log
> >
> > root@pogo:~# iwconfig  wlan3
> > wlan3     IEEE 802.11b  ESSID:""  Nickname:""
> >           Mode:Managed  Channel:0  Access Point: Not-Associated
> >           Bit Rate:0 kb/s   Tx-Power:0 dBm   Sensitivity=1/1
> >           Retry:off   RTS thr:off   Fragment thr:off
> >           Encryption key:off
> >           Power Management:off
> >           Link Quality=0/70  Signal level=-256 dBm  Noise level=-256 dBm
> >           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
> >           Tx excessive retries:0  Invalid misc:0   Missed beacon:0
> >
> > root@pogo:~# wc -l /tmp/ath_hal.log
> > 14425 /tmp/ath_hal.log
> >
> > 6. Parse the regdump stuff, it looks nasty:
> >
> > perl -pe 's,\x00,,g' < /tmp/ath_hal.log >  /tmp/ath_hal.log.txt
> >
> > In the end you should see lines like this:
> >
> > R:0x04004 = 0x00010000 - unknown
> > W:0x04004 = 0x00000000 - unknown
> > R:0x04010 = 0x00010014 - unknown
> > R:0x04004 = 0x00000000 - unknown
> > W:0x04004 = 0x00000000 - unknown
> > ...
> >
> > -- Sending dumps --
> >
> > Please feel free to post dumps of hardware to ath5k-devel@lists.ath5k.org
> >
> > In doing so you should also provide ath_info dump:
> >
> > cd trunk/tools
> > make
> > lspci -v
> > # look for the line like:
> > # Memory at b8000000 (32-bit, non-prefetchable) [size=64K]
> > # for your card, put 0x in front of it as and fun ath_info with it:
> > sudo ./ath_info 0xb8000000
> >
> > You should get something like:
> >
> > ---
> >
> >  -==Device Information==-
> > MAC Version:  5212 (0x50)
> > MAC Revision: 5213A(0x59)
> > PHY Revision: 5112a(0x36)
> >  -==EEPROM Information==-
> > EEPROM Version:     5.2
> > EEPROM Size:        16K
> > Regulatory Domain:  0x10
> >  -==== Capabilities ====-
> >
> > |  802.11a Support: yes  |
> > |  802.11b Support: yes  |
> > |  802.11g Support: yes  |
> > |  RFKill  Support: no   |
> > |  32KHz   Crystal: yes  |
> >
> >  ========================
> > GPIO registers: CR 00000000 DO 00000000 DI 00000000
> >
> > ---
> >
> > Other tips:
> >
> > If you are sending dumps please add stuff to the regdump which
> > indicates what you did to trigger a section of reg reads/writes.
> >
> > The dumps can be pretty big so please compress the file with bzip2. If
> > you can host the file somewhere and just send us the URL that may
> > help.
> >
> >   Luis
> > _______________________________________________
> > ath5k-devel mailing list
> > ath5k-devel@lists.ath5k.org
> > https://lists.ath5k.org/mailman/listinfo/ath5k-devel
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


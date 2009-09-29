Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web23102.mail.ird.yahoo.com ([217.146.189.42]:39328 "HELO
	web23102.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751316AbZI2I5k convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Sep 2009 04:57:40 -0400
Message-ID: <999306.93095.qm@web23102.mail.ird.yahoo.com>
Date: Tue, 29 Sep 2009 08:51:02 +0000 (GMT)
From: Hin-Tak Leung <hintak_leung@yahoo.co.uk>
Subject: compat-wireless tracepoint error Re: [Ndiswrapper-general] Need help to create driver for Netgear WN111v2
To: Malte Gell <malte.gell@gmx.de>
Cc: ndiswrapper-general@lists.sourceforge.net,
	linux-wireless@vger.kernel.org
In-Reply-To: <200909290956.49681.malte.gell@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--- On Tue, 29/9/09, Malte Gell <malte.gell@gmx.de> wrote:

> "Hin-Tak Leung" <hintak_leung@yahoo.co.uk>
> wrote
> 
> > --- On Tue, 29/9/09, Malte Gell <malte.gell@gmx.de>
> wrote:
> > > I prefer to wait ;-) This way I can stick with
> kernel
> > > 2.6.27 and just install
> > > this package, otherwise I would have to upgrade
> my kernel,
> > > because ar9170
> > > needs kernel >= 2.6.29 as far as I know. And i
> always
> > > fear, a kernel update
> > > could break other things,
>  
> > Where did you learn this from? It says bleeding-edge
> compat-wireless
> > (http://linuxwireless.org/en/users/Download#Compat-wireless_release_types)
> > requires Kernel >= 2.6.27 . and it is not a *full*
> kernel update -
> 
> Yes, compat-wirless-2.6 needs kernel 2.6.27, but, the
> ar9170 driver requires 
> kernel 2.6.29, below you can see the "make" output when
> building compat-
> wireless-2.6 from today on kernel 2.6.27. It is this
> tracepoint issue that 
> requires kernel 2.6.29
> 
> Regards
> Malte

Hmm, I see you have already posted to linux-wireless and already got your answers. Hauke has already given you the answer - your kernel tree is *not* 2.6.27(.0), and as it is obvious that you have 2.6.27.29-0.1, which is 2.6.27.29 + suse-patches. Even 2.6.27.29 is not 2.6.27(.0), but somewhat closer to 2.6.28. And you really have already had your answer - your tree is somewhat between 2.6.27 and 2.6.28, and *neither*. 

My suggestion would be simply to delete all the 'error: redefinition' parts from net/compat-2.6.28.h , because you already have them in the suse tree.
You may also need to delete something from net/compat-2.6.28.c, but that will happen during the linking stage (much later).

> 
> 
> ./scripts/driver-select ar9170
> 
> make
> 
> ./scripts/gen-compat-autoconf.sh config.mk >
> include/linux/compat_autoconf.h
> make -C /lib/modules/2.6.27.29-0.1-k7/build 
> M=/home/malte_gell/download/src/wifi/compat-wireless-2009-09-29
> modules
> make[1]: Entering directory `/usr/src/linux-2.6.27.29-0.1'
>   LD     
> /home/malte_gell/download/src/wifi/compat-
> wireless-2009-09-29/drivers/net/wireless/ath/built-in.o
>   CC [M] 
> /home/malte_gell/download/src/wifi/compat-
> wireless-2009-09-29/drivers/net/wireless/ath/main.o
> In file included from
> /home/malte_gell/download/src/wifi/compat-
> wireless-2009-09-29/include/net/compat.h:19,
>              
>    from <command-line>:0:
> /home/malte_gell/download/src/wifi/compat-
> wireless-2009-09-29/include/net/compat-2.6.28.h:152: error:
> redefinition of 
> ‘struct tracepoint’
> In file included from
> /home/malte_gell/download/src/wifi/compat-
> wireless-2009-09-29/include/net/compat.h:19,
>              
>    from <command-line>:0:
> /home/malte_gell/download/src/wifi/compat-
> wireless-2009-09-29/include/net/compat-2.6.28.h:182:1:
> warning: "DEFINE_TRACE" 
> redefined
> In file included from include/linux/module.h:19,
>              
>    from include/linux/textsearch.h:7,
>              
>    from include/linux/skbuff.h:26,
>              
>    from
> /home/malte_gell/download/src/wifi/compat-
> wireless-2009-09-29/include/net/compat-2.6.28.h:10,
>              
>    from
> /home/malte_gell/download/src/wifi/compat-
> wireless-2009-09-29/include/net/compat.h:19,
>              
>    from <command-line>:0:
> include/linux/tracepoint.h:86:1: warning: this is the
> location of the previous 
> definition
> /home/malte_gell/download/src/wifi/compat-
> wireless-2009-09-29/include/net/compat-2.6.28.h:186: error:
> redefinition of 
> ‘tracepoint_update_probe_range’
> include/linux/tracepoint.h:100: error: previous definition
> of 
> ‘tracepoint_update_probe_range’ was here
> make[4]: *** [/home/malte_gell/download/src/wifi/compat-
> wireless-2009-09-29/drivers/net/wireless/ath/main.o] Fehler
> 1
> make[3]: *** [/home/malte_gell/download/src/wifi/compat-
> wireless-2009-09-29/drivers/net/wireless/ath] Fehler 2
> make[2]: *** [/home/malte_gell/download/src/wifi/compat-
> wireless-2009-09-29/drivers/net/wireless] Fehler 2
> make[1]: ***
> [_module_/home/malte_gell/download/src/wifi/compat-
> wireless-2009-09-29] Fehler 2
> make[1]: Leaving directory `/usr/src/linux-2.6.27.29-0.1'
> make: *** [modules] Fehler 2
> 
> 


      

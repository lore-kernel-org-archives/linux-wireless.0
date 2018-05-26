Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dnvrco-outbound-snat.email.rr.com ([107.14.73.226]:47141 "EHLO
        dnvrco-cmomta01.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754842AbeEZOdK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 26 May 2018 10:33:10 -0400
Message-ID: <20180526143308.CO49W.49588.root@dnvrco-web22> (sfid-20180526_163403_925778_19982813)
Date: Sat, 26 May 2018 14:33:08 +0000
From: <mgreger@cinci.rr.com>
To: sedat.dilek@gmail.com
Subject: Re: Atheros AR9462 - 5Ghz not working
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <CA+icZUX+p2feWOnXSA=m3i+r560Mo2kHsadT4qFhx8VvUv_k8A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


---- Sedat Dilek <sedat.dilek@gmail.com> wrote: 
> On Tue, May 22, 2018 at 7:21 PM,  <mgreger@cinci.rr.com> wrote:
> > I've run out of ideas and am hoping someone here can help.
> >
> > All I want to do is connect a client to my 5Ghz network.
> >
> > My client:
> >   OS is Debian stable "Stretch" with sysvinit instead of systemd
> >   Atheros AR9462 (World roaming 0x64 regdomain in EEPROM)
> >   "iw reg set US"
> >   "iw list" shows both 2.4Ghz and 5Ghz bands available.
> >   "iw wlp3s0 survey dump" shows received traffic on 5Ghz bands.
> >
> > There are oodles of 5Ghz AP's within range, but scans (including passive scans) reveal only 2.4Ghz networks. My only guess was that it won't transmit due to regulatory requirements, but I cannot make it work.
> >
> > What I've tried:
> >   Running with and without CRDA
> >   Running latest mainline kernel
> >   Hacking around on the ath9k driver and nl80211 to remove all regulatory enforcement.
> >
> > Nothing works and I'm pulling my hair out. Any help would be greatly appreciated.
> 
> Hi,
> 
> I try to give some initial help.
> 
> The linux-wireless driver is supported by ath9k driver see [1] and [2].
> 
> Unfortunately, you have not sent any log-files at least your dmesg-log.
> No output of the above userspace commands or userspace-tools versions.
> No information to VendorID/ProductID (PCI, USB, whatever).
> It's not clear to me if this is a kernelspace (ath9k-driver) or
> userspace (CRDA/regulatory) problem.
> How should someone help you effectively?
> 
> The linux-wireless wiki has somne informations on how to debug
> Atheros/Qualcomm ath9k-driver, see [3].
> 
> As a debianist I say try Linux v4.16 Debian packages from
> stretch-backports (and maybe a higher version of wireless-regdb).
> 
> Try to ask questions the smart way [4] :-).
> 
> Hope this helps.
> 
> Regards,
> - Sedat -
> 
> [1] https://wireless.wiki.kernel.org/en/users/drivers/ath9k
> [2] https://wireless.wiki.kernel.org/en/users/drivers/ath9k/devices
> [3] https://wireless.wiki.kernel.org/en/users/drivers/ath9k/debug
> [4] http://www.catb.org/esr/faqs/smart-questions.html


Oops, in my first reply I listed base_eeprom twice. The second one should read modal_eeprom. The data is correct, the file name is not.

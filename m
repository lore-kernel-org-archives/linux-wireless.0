Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mo4-p05-ob.smtp.rzone.de ([81.169.146.180]:54183 "EHLO
	mo4-p05-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758478AbbJHUkO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Oct 2015 16:40:14 -0400
Date: Thu, 8 Oct 2015 22:33:55 +0200
From: Stefan Lippers-Hollmann <s.l-h@gmx.de>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Jakub Sitnicki <jsitnicki@gmail.com>,
	linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
	Larry.Finger@lwfinger.net
Subject: Re: [PATCH 1/1] New driver: rtl8xxxu (mac80211)
Message-ID: <20151008223355.248614c9@mir> (sfid-20151008_224019_384807_A7E6E9E1)
In-Reply-To: <wrfjio6h18jq.fsf@redhat.com>
References: <1440883083-32498-1-git-send-email-Jes.Sorensen@redhat.com>
	<1440883083-32498-2-git-send-email-Jes.Sorensen@redhat.com>
	<87d1wp49ds.fsf@frog.home>
	<wrfjio6h18jq.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

On 2015-10-08, Jes Sorensen wrote:
> Jakub Sitnicki <jsitnicki@gmail.com> writes:
> > Hi Jes,
> >
> > On Sat, Aug 29, 2015 at 11:18 PM CEST, Jes.Sorensen@redhat.com wrote:
> >> This is an alternate driver for a number of Realtek WiFi USB devices,
> >> including RTL8723AU, RTL8188CU, RTL8188RU, RTL8191CU, and RTL8192CU.
> >> It was written from scratch utilizing the Linux mac80211 stack.
> >>
> >> After spending months cleaning up the vendor provided rtl8723au
> >> driver, which comes with it's own 802.11 stack included, I decided to
> >> rewrite this driver from the bottom up.
> >
> > In the long term, do you plan for this driver to support the
> > RTL8188EU-based devices as well?
> 
> I have an 8188EU dongle in my wifi dongle pouch, together with several
> other yet to be supported ones :) I am currently trying to get the
> 8723BU and 8192EU working, but I haven't had time to work much on the
> 8188EU yet.
[...]

I was wondering about a pretty similar question, do you see this driver 
as being potentially compatible with rtl8192su[1] or rtl8192du[2] devices
or are these too different[3]?

Regards
	Stefan Lippers-Hollmann

[1]	currently supported by the staging r8712u driver
	or https://github.com/chunkeey/rtl8192su
	ID 0bda:8171 Realtek Semiconductor Corp. RTL8188SU 802.11n WLAN Adapter
	ID 0bda:8172 Realtek Semiconductor Corp. RTL8191SU 802.11n WLAN Adapter
[2]	currently no mainline support, 
	https://github.com/lwfinger/rtl8192du/commits/kernel-version
	as a dual-band device coming in multiple flavours, this might
	be a bit harder to support.
	ID 0bda:8194 Realtek Semiconductor Corp.
[3]	they obviously aren't covered yet, as rtl8xxxu doesn't know
	about their USB IDs/ firmware or initialisation routines 
	(respectively 5 GHz support in case of rtl8192du).

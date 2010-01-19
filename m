Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f187.google.com ([209.85.210.187]:62665 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755050Ab0ASTkQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jan 2010 14:40:16 -0500
Received: by yxe17 with SMTP id 17so5350592yxe.33
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jan 2010 11:40:14 -0800 (PST)
Message-Id: <AFBB72C4-DA31-4E0B-8410-E1399E802817@gmail.com>
From: Eric Volker <evolker@gmail.com>
To: Jouni Malinen <j@w1.fi>,
	Linux Wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20100119171116.GA16616@jm.kir.nu>
Content-Type: text/plain;
	charset=us-ascii;
	format=flowed;
	delsp=yes
Mime-Version: 1.0 (iPhone Mail 7D11)
Subject: Re: eapol_version=1 required for OS X clients?
Date: Tue, 19 Jan 2010 13:39:55 -0600
References: <1263876237.2619.1.camel@fwdell4550> <20100119171116.GA16616@jm.kir.nu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks for the informative response. Please see below for more...

On Jan 19, 2010, at 11:11 AM, Jouni Malinen <j@w1.fi> wrote:

> On Mon, Jan 18, 2010 at 10:43:56PM -0600, Eric Volker wrote:
>
>> Is EAP version 1 secure?
>
> It is not EAP version; it is EAPOL version.. In practice, there is no
> difference in how hostapd behaves as far as version 1 and 2 are
> concerned apart from the value in the header.

Thanks for clarifying that.

>
>> In light of this issue, why is version 2 default? Is there any way to
>> negotiate the version level? Which version do off-the-shelf consumer
>> routers use?
>
> hostapd is implemented based on 802.1X-2004 and version 2 and as such,
> version number 2 is the correct value to use. I would expect
> off-the-shelf consumer products use a mix of both version 1 and 2. I
> haven't checked this lately, but version 2 started showing up years  
> ago
> in many devices.
>
> IEEE 802.1X-2004 (and already the earlier -2001 version) described
> version negotiation mechanism for EAPOL. There are some  
> implementations
> that did not do this correctly and had problems when -2004 was
> introduced (over fixe years ago!).
>
>> Based on the comments in hostapd.conf, EAP only seems to be used for
>> 802.1X authentication. I'm using WPA/WPA2 (wpa=3) Personal
>> authentication, so why does the EAP version matter?
>
> Because it is not "EAP version", but "EAPOL version" and
> WPA/WPA2-Personal uses EAPOL frames.
>
>> Why is an OS as recent as Snow Leopard (10.6) using a protocol  
>> version
>> that the hostapd.conf comments imply is outdated?
>
> It would be fine to use protocol version 1, but the real question here
> is why does it not implement IEEE 802.1X version negotiation  
> correctly..
> Anyway, I do not think I've seen this with OS X tests myself (both  
> 10.4
> and 10.6), but do not remember details.. In other words, this could be
> an issue in a component (just the driver?) and not the generic
> supplicant in the OS.
Is it possible that I set something incorrectly in hostapd.conf that  
is causing interaction problems between OS X and EAPOL v2? I played  
with several options before finding a combination that would work.  
Perhaps it would be best to start with a clean hostapd.conf or even a  
clean install of Ubuntu. I did try three different OS X clients with  
different hardware, and they all failed to connect with EAPOL v2.

Here is the link that prompted me to try v1:

http://list.voyage.hk/pipermail/voyage-linux/2006-March/000748.html

That user specified EAP, not EAPOL but I think he may have been  
confused, as I was.

I don't know if it's related, but I'm also experiencing an issue where  
the AP stops working after an undetermined period of time. It stops  
beaconing and previously associated clients can no longer connect.  
I'll save that issue for a new email.

Thanks,

Eric Volker


>
> -- 
> Jouni Malinen                                            PGP id  
> EFC895FA

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:63269 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932984Ab1LFI1v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Dec 2011 03:27:51 -0500
Received: by ggnr5 with SMTP id r5so5973860ggn.19
        for <linux-wireless@vger.kernel.org>; Tue, 06 Dec 2011 00:27:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAOeh9MvgzNnToPMSwt0_QX+T5T63dJDuekoUOU6_JcbFDmXV-g@mail.gmail.com>
References: <CAOeh9MuuJtK_edMQvVaLSRytRoFix_OuW4OEcEMDYEak1=CvMw@mail.gmail.com>
	<CAB3XZEf=jrrqZk58BnV8Gi4iKJ6N6c24M_eLnz816n==kuxmHA@mail.gmail.com>
	<CAOeh9MsqTQT6qzd47Af674cK4KQHN=uOaG-u1hVWV9faeb2Mwg@mail.gmail.com>
	<CAB3XZEf4sm66WzG49jYsig=wzip0m2w87tud2Es0wd4aXV2Fqw@mail.gmail.com>
	<CAOeh9MuGyhwC3swbaZWjQ4+qvsVkofR13j=UX-Rjx0KENw8wgQ@mail.gmail.com>
	<CAOeh9MvgzNnToPMSwt0_QX+T5T63dJDuekoUOU6_JcbFDmXV-g@mail.gmail.com>
Date: Tue, 6 Dec 2011 10:27:50 +0200
Message-ID: <CAB3XZEdET1qMDHE9AJN7r-dmKdhAXz=MTBZbeNYzj87s4Oaozg@mail.gmail.com> (sfid-20111206_092800_775431_209A7C39)
Subject: Re: Query on ieee80211_subif_start_xmit
From: Eliad Peller <eliad@wizery.com>
To: uday kiran <kaniki.uday@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 6, 2011 at 10:17 AM, uday kiran <kaniki.uday@gmail.com> wrote:
> Any pointers ?
>
> On 12/5/11, uday kiran <kaniki.uday@gmail.com> wrote:
>> Is ieee80211_subif_start_xmit the standard function called for frame
>> conversion ? Or will it change based on the driver under use ?
>>
>> For frame conversion to work , is it must to add eth and wlan
>> interfaces to the bridge interface?
>>
>> Is it that once 802.3 stack understands that the dest mac is on wi-fi
>> interface , it calls this function ?
>>
>> Please clarify.
>>
The proper xmit function will be called according to the netdev used
to send the packet.
for mac80211's netdev:

static const struct net_device_ops ieee80211_dataif_ops = {
[...]
	.ndo_start_xmit		= ieee80211_subif_start_xmit,
[...]
};

Eliad.

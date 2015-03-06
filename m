Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f173.google.com ([209.85.214.173]:38295 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754628AbbCFXwB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Mar 2015 18:52:01 -0500
Received: by obcwo20 with SMTP id wo20so23875957obc.5
        for <linux-wireless@vger.kernel.org>; Fri, 06 Mar 2015 15:52:01 -0800 (PST)
Message-ID: <54FA3D9E.40107@lwfinger.net> (sfid-20150307_005206_655784_41BD262E)
Date: Fri, 06 Mar 2015 17:51:58 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Jes.Sorensen@redhat.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/1] New driver: rtl8723au (mac80211)
References: <1425680126-25928-1-git-send-email-Jes.Sorensen@redhat.com>
In-Reply-To: <1425680126-25928-1-git-send-email-Jes.Sorensen@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/06/2015 04:15 PM, Jes.Sorensen@redhat.com wrote:
> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>
> This is a new driver for the rtl8723au which was written from scratch,
> to utilize the Linux mac80211 stack.
>
> This has been a pet project for me for some time I finally feel it
> is stable enough to submit. I have used it for a while without any
> serious issues.
>
> I started working on cleaning up the vendor provided driver in
> staging/rtl8723au over a year ago. After spending 6 months on it, it
> became obvious to me that it was a rather hopeless task, and I started
> writing this driver from scratch. I do not have any specs for the
> chip, so everything is based on knowledge I obtained from dissecting
> the vendor driver.
>
> Special thanks to Larry Finger for help with the original rtl8723au
> driver, and Johannes Berg for answering all my silly questions about
> 802.11 innards and the mac80211 stack. Had I known then what I know
> today about 802.11, I probably would never have so mad as to start
> this project in the first place!
>
> Cheers,
> Jes

Jes,

Congratulations. You did something that I have wanted to do for some time, but I 
have never found the time. I hope a roadmap will help.

I do have some suggestions:

The name of your driver should be rtl8723au, rather than rtl8xxxu. When 
introducing any Realtek drivers into staging, I was careful to use only r8xxxyy 
so that the full rtl name would not conflict. This naming scheme also allows the 
possibility of adding more drivers such as RTL8723BU, RTL8188EU, RTL8192DU, etc. 
I also think that this code should be placed in a separate sub directory under 
drivers/net/wireless. If you want a separate directory, the name rtl8xxxu would 
be appropriate. I think it would also work to put these drivers in rtlwifi. Any 
of these other drivers should be able to share routines with this one, probably 
in the form of mini drivers such as rtlwifi for the PCI devices.

I will do a review of the code, and I will have some suggestions there.

Thanks,

Larry


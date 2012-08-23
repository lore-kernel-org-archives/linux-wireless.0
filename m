Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:41073 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932341Ab2HWRHx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Aug 2012 13:07:53 -0400
Received: by vcbfk26 with SMTP id fk26so1068159vcb.19
        for <linux-wireless@vger.kernel.org>; Thu, 23 Aug 2012 10:07:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <50365AC8.7030503@lwfinger.net>
References: <CAE3CJbkhmZ75gBjEToshQ2M9Xu7ciVrDtv8n2DVZepnhBoNt-Q@mail.gmail.com>
	<50365AC8.7030503@lwfinger.net>
Date: Thu, 23 Aug 2012 10:07:52 -0700
Message-ID: <CAE3CJbm5a0hZ8uWT8yU5Z8vbKX2HNwZ2uPUFULGA-3no1XFc_Q@mail.gmail.com> (sfid-20120823_190757_623484_5F3FAD99)
Subject: Re: Question about ath9k/mac80211 Driver
From: Patrick Connolly <pjc999@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry,
     Thanks for the response.  It appears that "set bitrates" is not
possible with my version of iw (0.9.19) - I get a big long help screen
when I try that command:

 "iw dev wlan0 set bitrates legacy-2.4 1 2 5.5 11"
...the options printed out for "set" are:

        phy <phyname> set distance <distance>
        phy <phyname> set coverage <coverage class>
        phy <phyname> set netns <pid>
        phy <phyname> set rts <rts threshold|off>
        phy <phyname> set frag <fragmentation threshold|off>
        dev <devname> set channel <channel> [HT20|HT40+|HT40-]
        phy <phyname> set channel <channel> [HT20|HT40+|HT40-]
        dev <devname> set freq <freq> [HT20|HT40+|HT40-]
        phy <phyname> set freq <freq> [HT20|HT40+|HT40-]
        phy <phyname> set name <new name>
        dev <devname> set type <type>
        dev <devname> set meshid <meshid>
        dev <devname> set monitor <flag>*
        dev <devname> set mesh_param <param> <value>

 ...also there's the issue of "basic rates" and "supported rates" I
would need the supported rates appropriate for the mode (such as 'b')
to show in the beacon also.

Thanks again for the response.

-Patrick


On Thu, Aug 23, 2012 at 9:31 AM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> On 08/23/2012 11:19 AM, Patrick Connolly wrote:
>>
>> Mohammed,
>>       Thanks very much for the response.
>>
>>     Yes I get "Operation not supported":
>>
>> # iwconfig wlan0 modu 11b
>> Error for wireless request "Set Modulation" (8B2F) :
>>      SET failed on device wlan0 ; Operation not supported.
>>
>>     ...so what does this mean; what are my options here?  In view of
>> the fact that the capability of changing modes (from 'g' to 'b'
>> ...etc.) is an essential requirement, am I using the wrong driver
>> ...is there a different driver that supports this chip?  Or is it that
>> there's no driver that supports this chip so that I would have to put
>> this functionality into ath9k myself if I want it?
>
>
> Adding that functionality should not be necessary. The simple command
>
> iw dev $WIFIDEV set bitrates legacy-2.4 1 2 5.5 11
>
> will restrict the device to 802.11b rates, which I think is what you want.
> This command does not involve the device driver, but sets the appropriate
> parameters in mac80211.
>
> Larry
>
>

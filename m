Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:39084 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678Ab2FOQxY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jun 2012 12:53:24 -0400
Received: by ghrr11 with SMTP id r11so2493219ghr.19
        for <linux-wireless@vger.kernel.org>; Fri, 15 Jun 2012 09:53:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FDB5E52.1020608@qca.qualcomm.com>
References: <1339203070-17979-1-git-send-email-rodrigue@qca.qualcomm.com>
 <1339228530.4539.0.camel@jlt3.sipsolutions.net> <4FD3A936.8070600@broadcom.com>
 <1339399952.4520.13.camel@jlt3.sipsolutions.net> <4FD60369.80108@qca.qualcomm.com>
 <1339425944.4520.27.camel@jlt3.sipsolutions.net> <20120614193104.GD32257@tux>
 <1339748211.4512.6.camel@jlt3.sipsolutions.net> <4FDAF096.200@qca.qualcomm.com>
 <4FDB1740.60707@broadcom.com> <4FDB5E52.1020608@qca.qualcomm.com>
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Fri, 15 Jun 2012 09:53:03 -0700
Message-ID: <CAB=NE6X=pO5c_yUqMmqU1jm92WJKqBbYioYm-2S4AYS2JXYRTA@mail.gmail.com> (sfid-20120615_185328_195463_A155D9DC)
Subject: Re: [RFC 0/3] wireless: add CONFIG_CFG80211_EXPERT
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: Arend van Spriel <arend@broadcom.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, me@bobcopeland.com,
	mickflemm@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 15, 2012 at 9:09 AM, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> On 06/15/2012 02:06 PM, Arend van Spriel wrote:
>> On 06/15/2012 10:21 AM, Kalle Valo wrote:
>>> On 06/15/2012 11:16 AM, Johannes Berg wrote:
>>>>> As for a name, I thought about it for a while and given that we have different
>>>>>> "wireless" technologies -- bluetooth, NFC, naming this CONFIG_WIRELESS_EXPERT
>>>>>> seemed odd, and given that our 802.11 framework is under cfg80211 naming it
>>>>>> CONFIG_CFG80211_EXPERT seemed appropriate. But even if its under cfg80211
>>>>>> perhaps something more explicit about the implications may be better, how
>>>>>> about CONFIG_CFG80211_MAY_BREAK_CERTIFICATION ?
>>>>
>>>> Or you could just be explicit about it and call it
>>>> CONFIG_WIRELESS_REGULATORY_BREAKAGE or something like that :-)
>>>
>>> CONFIG_WIRELESS_CERTIFIED?
>>
>> That one looks familiar ;-)
>
> Sorry, did you suggest that already? I missed that. I guess I need to
> start organising my email better :)

We have CONFIG_ATH9K_DFS_CERTIFIED. I like something like
CONFIG_CFG80211_MAY_BREAK_CERTIFICATION given that
CONFIG_WIRELESS_CERTIFIED only assumes the kconfig options it would
depend on are all neatly  developed but they could be still under
development. The only thing about
CONFIG_CFG80211_MAY_BREAK_CERTIFICATION is I suspect not many folks
would be willing to ship with that enabled at all even *after* they do
their homework.

So how about CONFIG_CFG80211_CERTIFICATION_ONUS which can be defined
as an option for features / options whereby the onus for regulatory
certification is being accepted by the option enabler? Pretty simple
and to the point, and would allow for research code but also code
whereby a bit more work is required on the enabler like DFS
certification.

  Luis

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f52.google.com ([209.85.161.52]:52894 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754238Ab1F2NnY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 09:43:24 -0400
Received: by fxd18 with SMTP id 18so1247597fxd.11
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jun 2011 06:43:23 -0700 (PDT)
Message-ID: <4E0B2BF8.6090300@fedoraproject.org> (sfid-20110629_154331_167099_36C810D3)
Date: Wed, 29 Jun 2011 15:43:20 +0200
From: Michel Alexandre Salim <salimma@fedoraproject.org>
MIME-Version: 1.0
To: Jouni Malinen <j@w1.fi>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <jmalinen@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Subject: Re: [PATCH] ath9k: add module option for disabling 11n functionality
References: <4E0A2F8A.8010102@fedoraproject.org> <20110628215757.GA14975@jm.kir.nu> <4E0AE8C1.9090809@fedoraproject.org> <20110629130910.GA2688@jm.kir.nu>
In-Reply-To: <20110629130910.GA2688@jm.kir.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/29/2011 03:09 PM, Jouni Malinen wrote:
> On Wed, Jun 29, 2011 at 10:56:33AM +0200, Michel Alexandre Salim wrote:
>> I agree with you and Adrian; it should ideally be in the 802.11
>> stack. But as Ben noted, it does have a useful purpose -- for
>> debugging.
>>
>> If the maintainers are agreeable to a shared mac80211 mechanism,
>> which is the preferred way to handle this -- get this in, then
>> refactor *both* iwlagn and ath9k to use it, or to implement a shared
>> mechanism, demonstrate it with ath9k, then fix iwlagn later?
>
> I don't follow this.. Why would we get this into ath9k first if the more
> appropriate way of doing this would be to modify mac80211 in the first
> place. I see no point in doing driver specific hacks for this unless
> there really is some driver specific issues that are being worked around
> and that does not seem to be the case here.
>
The argument would be that driver-specific implementations are easier to 
get committed, and less intrusive than a general framework, but yes, I 
would prefer a more general solution myself.

> As far as being able to disable 802.11n in general is concerned, it
> would much better to do that as a parameter for the connection (e.g.,
> new nl80211 attribute for NL80211_CMD_ASSOCIATE) rather than a module
> parameter. This workaround seems to be needed with some APs and global
> disabling of 802.11n does not sound like the ideal mechanism for that.

Would this not require modifications to e.g. NetworkManager, ConnMan 
etc.  as well? While a module parameter is not an ideal workaround, it's 
at least easy to use. If this goes in as a connection parameter, it'd be 
nice to still have a way of manually adjusting it through a command-line 
tool.

My first attempt to solve this was to use 'iwconfig wlan0 set rate 54M' 
-- but this yields "Operation not supported". How about making a request 
for a rate of 54M or below switch the device to 802.11g mode (and 
optionally, a rate of 11M or below => 802.11b mode)? That way we don't 
need to invent a new interface at all. How would I go about adding 
support for rate setting requests to the driver?

Thanks,

-- 
Michel Alexandre Salim
µblog:      http://identi.ca/hircus
             http://twitter.com/hircus
GPG key ID: 78884778

()  ascii ribbon campaign - against html e-mail
/\  www.asciiribbon.org   - against proprietary attachments

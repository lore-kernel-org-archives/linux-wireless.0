Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62425 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596Ab2BVXfo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Feb 2012 18:35:44 -0500
Received: by mail-iy0-f174.google.com with SMTP id b35so694040iac.19
        for <linux-wireless@vger.kernel.org>; Wed, 22 Feb 2012 15:35:44 -0800 (PST)
Message-ID: <4F457BCD.5020200@lwfinger.net> (sfid-20120223_003550_294868_1602F234)
Date: Wed, 22 Feb 2012 17:35:41 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: htl10@users.sourceforge.net
CC: Attila Fazekas <turul64@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Herton Ronaldo Krzesinski <herton@canonical.com>
Subject: Re: [PATCH] rtl8187: Add Ad-hoc mode
References: <1329947497.90659.YahooMailClassic@web29504.mail.ird.yahoo.com>
In-Reply-To: <1329947497.90659.YahooMailClassic@web29504.mail.ird.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/22/2012 03:51 PM, Hin-Tak Leung wrote:
> --- On Tue, 21/2/12, Attila Fazekas<turul64@gmail.com>  wrote:
>
>> I think it is worth the effort.
>>
>> Hostapd AFAIK is not working with rtl8187 now.
>> Until we can make it work in master mode, the adhoc mode
>> could be an
>> alternative. I think even if we can use it in master mode,
>> ad-hoc mode
>> should be implemented.
>
> You (and others) could comment on the issue of not-working hostapd a bit more; we might want to get it working properly anyway.
>
> As Larry requested - please send the patch without munching from your
> e-mail client. Since you are on gmail, I could offer a little advice on git-send-email, which may or may not be something you already know. This is what I do to send patches from my gmail account (change "name" and "acct" and "FILLTHISIN" and "patch-file" to suit yourself), and you could add --cc a few of us there also:
>
> git send-email --from 'name<acct@gmail.com>' \
> --to linux-wireless@vger.kernel.org --to linville@tuxdriver.com \
> --smtp-server smtp.gmail.com --smtp-server-port 465 --smtp-user \ acct@gmail.com --smtp-pass FILLTHISIN --smtp-ssl patch-file
>
> You can do "man git-send-email" (all git man pages uses "git-something" to document the "git something" sub commands, with a dash between) to read about all the switches and what they are supposed to do.
>
>> About refactoring:
>>
>> rtl8180_beacon_work()
>> Now is almost the same, I think it is possible to make it
>> generic by a
>> macro, or by creating new source/object file linked to both
>> driver, or
>> even possible to create a common module.
>> But, this function will be different if someone will be able
>> to add
>> some hardware aided beacon timestamp update. (If I can have
>> more
>> information about this hardware I'll try it)
>> Creating a new common module just for one small function,
>> IMHO not
>> worth the effort.
>> Please advice.
>>
>> struct rtl8187_vif, struct rtl8180_vif  now are the
>> same, they might
>> be the same in the future as well.
>> We can remove them and create new one named rtl818x_vif in
>> the rtl818x.h .
>> Shall I do it ?
>
> I haven't got a strong opinion on this - but we probably like to try your patch out first :-).

If drivers rtl8180 and rtl8187 each end up with the same struct definition in 
their private headers, it certainly makes sense to place the code in a common 
header.

I fixed and tested your patch. With it, I certainly see the beacons and I was 
able to use NetworkManager to connect once. However, I was never able to ping 
from either end of the network to the other.

Besides the mangling of the patch by your mailer, you had many problems with 
spaces instead of tabs. Did you use scripts/checkpatch.pl to test for errors?

Larry


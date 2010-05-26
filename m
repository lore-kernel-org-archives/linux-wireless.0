Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:40722 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754877Ab0EZQVL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 May 2010 12:21:11 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 26 May 2010 09:21:11 -0700
From: David Quan <David.Quan@Atheros.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Michael Green <Michael.Green@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 26 May 2010 09:21:10 -0700
Subject: RE: wireless-regdb: A band is missing for IL
Message-ID: <93781E992CBA7843962D8B0E7D683F3C1117B01000@SC1EXMB-MBCL.global.atheros.com>
References: <AANLkTimkpbans5mUObR8PWzf2-Uh0K-cZVVg0HjNxnSv@mail.gmail.com>
	 <AANLkTikUhVoBKe95N_kkpXvSEsr845viGp5IhHZTVN2n@mail.gmail.com>
	 <93781E992CBA7843962D8B0E7D683F3C11178EC0E4@SC1EXMB-MBCL.global.atheros.com>
 <AANLkTin4UbuZOfpJ23KLq8HRfVcEKmHAAeEtSSxDE9Vu@mail.gmail.com>
In-Reply-To: <AANLkTin4UbuZOfpJ23KLq8HRfVcEKmHAAeEtSSxDE9Vu@mail.gmail.com>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 Unii1 = 5150 - 5250
 Unii2 = 5250 - 5350
http://en.wikipedia.org/wiki/U-NII

Currently our internal database shows no HT40 support for Israel in 5Ghz.
Only in 2Ghz it supports both HT20/40.

5) The allow of HT40 is not control by WFA, but by regulatory. So even if WFA allows HT40 general support in 5Ghz,
if the country do not allow it, it is not allowed.

6) Yes, however, I am not sure if ath9k supported this yet or not. Will chat with Luis.

David


-----Original Message-----
From: Emmanuel Grumbach [mailto:egrumbach@gmail.com] 
Sent: Tuesday, May 25, 2010 11:26 PM
To: David Quan
Cc: Luis R. Rodriguez; Michael Green; linville@tuxdriver.com; linux-wireless@vger.kernel.org
Subject: Re: wireless-regdb: A band is missing for IL

I don't know exactly what Unii1 and Unii2 means but, this is the
latest regulatory authoritative document (in hebrew):
http://www.moc.gov.il/sip_storage/FILES/1/1061.pdf
In short:

1. 5150 - 5250
2. 5250 - 5350 DFS mandatory
3. outdoor is forbidden for both
4. 200mW maximum e.i.r.p.
5. 40 Mhz is allowed for all WiFi Alliance equipment in 5.2GHz
6. 40 Mhz is allowed for WiFi Alliance equipment that have "40 MHz
operation in 2.4 GHz, with coexistence mechanisms" only

I know how to enforce 1 - 4. But 5 and 6 is another story....

Anyway, I will send an RFC soon.

Emmanuel Grumbach
egrumbach@gmail.com



On Tue, May 25, 2010 at 23:39, David Quan <David.Quan@atheros.com> wrote:
> Israel follows ETSI3_WORLD,
>  this means
>
> Unii1 + Unii2 is supported. Unii2 requires DFS for APs.
>
> 2ghz Ch1-13 supported.
>
>
> -----Original Message-----
> From: Luis R. Rodriguez [mailto:mcgrof@gmail.com]
> Sent: Tuesday, May 25, 2010 12:08 PM
> To: Emmanuel Grumbach; Michael Green; David Quan
> Cc: linville@tuxdriver.com; linux-wireless@vger.kernel.org
> Subject: Re: wireless-regdb: A band is missing for IL
>
> Michael, please review and let us know what you think.
>
>  Luis
>
> On Tue, May 25, 2010 at 12:03 AM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
>> According to http://en.wikipedia.org/wiki/List_of_WLAN_channels#5.C2.A0GHz_.28802.11a.2Fh.2Fj.2Fn.29
>>
>> Channels 34 - 64 are allowed in 20 Mhz in Israel. This is not what is
>> written in db.txt:
>>
>> country IL:
>>         (2402 - 2482 @ 40), (N/A, 20)
>>
>> This wikipedia page relies on an official page from the Israel
>> Ministry of the Communication.
>>
>> Emmanuel Grumbach
>> egrumbach@gmail.com
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>

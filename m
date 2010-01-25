Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f176.google.com ([209.85.211.176]:55489 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932131Ab0AYVNq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jan 2010 16:13:46 -0500
Received: by ywh6 with SMTP id 6so3486584ywh.4
        for <linux-wireless@vger.kernel.org>; Mon, 25 Jan 2010 13:13:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <69e28c911001251121i61be9c0bhed43648a12db42f6@mail.gmail.com>
References: <4B5CD1FF.4090209@twilightblue.net>
	 <b6c5339f1001250939r6d136927q51bba86f7102d826@mail.gmail.com>
	 <4B5DE859.6080409@lwfinger.net>
	 <69e28c911001251121i61be9c0bhed43648a12db42f6@mail.gmail.com>
Date: Mon, 25 Jan 2010 16:13:41 -0500
Message-ID: <b6c5339f1001251313u369c571dq5cee9ffa65fcf457@mail.gmail.com>
Subject: Re: Bug: 2.6.32 ath5k, associating with WEP128 AP is unreliable
From: Bob Copeland <me@bobcopeland.com>
To: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Don Darling <darling.don@gmail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/1/25 Gábor Stefanik <netrolller.3d@gmail.com>:
> On Mon, Jan 25, 2010 at 7:52 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
>> For the record, WEP104 and WEP128 are the same thing. The smaller number
>> makes it explicit that the 24-bit IV is transmitted in the open. The same
>> thing applies to WEP40 and WEP64.
>>
>
> Only one problem there is another, nonstandard WEP type where the
> actual key is 128-bit, and this is also sometimes referred to as
> WEP128 (with the same metric as WEP64, this one would be WEP152). Same
> goes for "WEP228/WEP256/WEP280".

Yea, I think ath hw supports that too:

#define AR5K_KEYTABLE_TYPE_40		0x00000000
#define AR5K_KEYTABLE_TYPE_104		0x00000001
#define AR5K_KEYTABLE_TYPE_128		0x00000003

at least that's what I assumed it meant.  But there's no way to set it
from mac80211 (nor should there be).

-- 
Bob Copeland %% www.bobcopeland.com

Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69D165695
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 09:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785490376; cv=none; b=ZOFeOtfGgwJdqY9ybWo0hl3fks0Si3uY9HpY8l54CfwG6+o/q3YK/CB1Yb5OsF1CJoVUClGloa8XBSYbX66i2+N2lv72j6xKr9fHWg/fAkbiNXfDN0ECFAuCgvqJW2ql+MB6I6bQx6GAsuUAw2FZq/4zYky145YVI51yVn35vro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785490376; c=relaxed/simple;
	bh=bog/a/CepUks6eehAj/J9afhSgaKBjqoJ/bJVyADqkI=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=GXIXLdRa9spUT3TAPOFcYn931xktLwpzYF+ad6dfWYMLYB+EuIY4NricZ2F4mbAk0MtH/zD6S6cw43DSoPC7POeElsYHbOYzIRopHkS1BUblBz9b7eypUMGtcxam2jE9XAvLeI2ugriUrGr5CnuXjdz5L9jkbG34i76f0MWxTB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rPXnjh+g; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rPXnjh+g"
Date: Fri, 31 Jul 2026 11:31:46 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785490371;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LijMCJNHT++jeJQxsL21UBhKOtkGbQApmMoT7bTi/5o=;
	b=rPXnjh+gisgwj0l86DKDMj3y14r/HRSbFsjYa7JKXbsh4sP0gLxdQGs6l1pe+1we8x3bSU
	OCq78nO9DS/cge9tcrgVsdqB4RqWfSx86LbxK6ATTAMuQZA4hBK6qGYeSExs+jN6kMafro
	NdsuIlsBK0xf3h2AQiaodkP+9VQDQx8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Luka Gejak <luka.gejak@linux.dev>
To: Ping-Ke Shih <pkshih@realtek.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Michael Straube <straube.linux@gmail.com>,
 Peter Robinson <pbrobinson@gmail.com>,
 Bitterblue Smith <rtl8821cerfe2@gmail.com>, luka.gejak@linux.dev
Subject: =?US-ASCII?Q?RE=3A_=5BPATCH_v2_01/11=5D_wifi=3A_rtw88=3A_add_?=
 =?US-ASCII?Q?the_RTL8723B_chip_type_and_SDIO_helper?=
In-Reply-To: <db7e5e0ee9fd4259a05db2e3fc08a5b1@realtek.com>
References: <774407603bef4fd38290f6b5d4b4a26c@realtek.com> <20260730074504.19725-1-luka.gejak@linux.dev> <6c2d5972971f48548a58dc3fba890793@realtek.com> <6872BF49-855E-42A5-A06F-98C4602B2C25@linux.dev> <db7e5e0ee9fd4259a05db2e3fc08a5b1@realtek.com>
Message-ID: <2AE57F1B-84FE-4BC6-A0E1-D8B61A90F3F0@linux.dev>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT

On July 31, 2026 3:29:40 AM GMT+02:00, Ping-Ke Shih <pkshih@realtek=2Ecom> =
wrote:
>
>Luka Gejak <luka=2Egejak@linux=2Edev> wrote:
>> On July 30, 2026 11:17:41 AM GMT+02:00, Ping-Ke Shih <pkshih@realtek=2E=
com> wrote:
>> >luka=2Egejak@linux=2Edev <luka=2Egejak@linux=2Edev> wrote:
>> >> it would be four callbacks (free page check, page
>> >> accounting, output queue wait, transfer sizing) and I did not want t=
o
>> >> introduce that structure without asking first=2E
>> > If these are called from sdio=2Ec, just check chip ID in sdio=2Ec=2E
>>
>> That is what v3 already does, so nothing changes there=2E All four are
>> reached from sdio=2Ec only=2E
>>
>> > If they are used by common flow like coex=2Ec, I prefer to implement
>> > them by chip_ops=2E
>>
>> Let me list them all so you can rule on all of them at once rather than
>> a file at a time=2E
>>
>> Two go regardless of your answer: the chip test inside
>> rtw8723bs_apply_basic_rates() and rtw8723bs_apply_bss_cap() is
>> redundant, both callers already establish the chip=2E In the second one
>> the NL80211_IFTYPE_STATION half of the same guard is still needed, so
>> only the chip half goes there=2E
>>
>> That leaves the following outside sdio=2Ec=2E
>>
>> coex=2Ec, 2 sites:
>>
>>   rtw_coex_scan_notify()    -> rtw_coex_8723bs_scan_notify()
>>   rtw_coex_connect_notify() -> rtw_coex_8723bs_connect_notify()
>>
>>   Each tests the chip and bt_disabled once and returns true when it has
>>   handled the notification; everything below them assumes both=2E
>>
>> mac80211=2Ec, 6 sites in rtw_ops_bss_info_changed(): the receive filter

One piece of context first, because it changes most of the answers
below=2E I ran the ablation you asked for in your other mail, and the
association register sequence is not needed, nor are the two
coexistence patches=2E Four patches are going from prep, which takes it
from ten to six=2E The measurements and the two corrections I owe you are
in my reply to that mail=2E

> Should receive filter implement in rtw_ops_configure_filter()?

Moot now, the receive filter handling goes with the patch I am
dropping=2E For the record you were pointing at something real, although
not quite where I first placed it=2E

rtw8723b=2Ec does seed hal=2Ercr in mac_init, so it is not the problem=2E =
The
asymmetry is in rtw_ops_configure_filter() itself: entering promiscuous
clears BIT_CBSSID_BCN and BIT_CBSSID_DATA together, but leaving it
restores only BIT_CBSSID_BCN=2E CBSSID_DATA is therefore gone from
hal=2Ercr for good after the first scan, on any chip, until the next
mac_init=2E That is what the per-association forcing was compensating
for=2E

There is a second one next to it: rtw8723x=2Ec writes WLAN_RCR_CFG
straight to REG_RCR in mac_init without putting it into hal=2Ercr, so on
8723D and 8703B the first configure_filter() call replaces it with the
core default from rtw_core_init(), which carries neither CBSSID bit nor
AMF=2E

Both look worth fixing on their own and I am happy to send that
separately if you agree with the reading=2E It is unrelated to this
series=2E

> Please check existing codes related to sec->default_key_search to see
> how to support RTL8723BS by the same flow=2E

You were right, and more strongly than you put it=2E
rtw_sec_enable_sec_engine() sets default_key_search itself and then
programs all four USE_DK bits on that basis, so my enable path was a
no-op and my disable path was clearing bits the core had deliberately
set=2E Both sites are gone with the patch, and 24 rekeys completed in the
soak without them=2E

> I don't object this=2E More, I'm considering if no need to check chips,
> just be a common flow=2E

Happy to try that=2E Dropping the chip test would make the zero length
check apply to every chip, so I would rather measure it on the 8703B
path than assume; I do not have that hardware=2E If you are comfortable
with it on inspection I will send it as a separate patch that removes
the test entirely rather than fold it in here=2E

> That looks fine=2E I remember I don't have comments on this part, no?

Correct, you had no comments on the reserved page patch itself, only on
the DWBCN1 define placement and the comment style, both fixed=2E The
inline chip test there stays=2E

> Did you mean callees of rtw_coex_8723bs_scan_workaround() ?
> I think you can go with your mind=2E

Yes, those were the ones, and thank you, but it is moot now that the
coexistence patches are going as well=2E

> I'd say the version copy many stuffs from vendor driver=2E However, we
> should rewrite and consider the proper places, and if it is actually
> necessary=2E The vendor driver is based on cfg80211, and many stuffs
> have been done by mac80211, so we don't need to implement them in
> rtw88=2E

That turned out to be exactly right=2E Four of the ten patches were
reproducing vendor behaviour that mac80211 or the core already handles,
and they only survived this long because I kept quoting bring-up
results instead of re-measuring them=2E Thanks for pushing on it twice=2E

Best regards,
Luka Gejak

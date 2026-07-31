Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 633E631B833
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 09:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785490379; cv=none; b=CxD6tjxTodK1oZm6DYxayUPCt/JECSvAfNtmPw69e8O37Yht7CxIma1tyjjtWP6Sjz2O0qlXRp/bybuNWUA4Mxx0GNwwq9VlfV5GIAM1M+YHs/bTvM8IcZAF8yTdqKQGKXTWi1vTTH/7rnk6hXvExUhFkDW2vsjUDlVtNP1ShSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785490379; c=relaxed/simple;
	bh=dlwi9ORZJbJt6lbm9zkJ0Q8U6kcu/WkQD4NM+EREXas=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=fRRZHMKVYWIy5SOzB+QqRoiF9FO0VoBjWlekdHfuacr4Ci70pQuVU1CR9WwRIlMr1+RpUVr5LlcM2UVwKMFnMW+iqjGwKp6Cu9pQ7E3q/GYtHCbEcv6LOP4wCbIXw/oBXzXfL/3Hgf3hhoDWgLMzEKCH8e2E7OiFmiCW/XBcluk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=GciR/+MZ; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="GciR/+MZ"
Date: Fri, 31 Jul 2026 11:32:48 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785490375;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1eEqjThMF8F5/P1t5TSHjTco6lItunOOzUbN+YBJ8RI=;
	b=GciR/+MZGvhjweUXSf0yizxn8cXykn4w9LCJT4i+QEoPN/DaBZlGj7yONvknHzoOYuT58z
	QcDvp+iG8QSC7M83qhu4Z1tYTwDgrGw/yVSzy0wT2krgMwR4G+I21S0thZZlCFVJKxirG1
	E7K2VBmcfCYAQ5DNQcyapBtpmF09XM0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Luka Gejak <luka.gejak@linux.dev>
To: Ping-Ke Shih <pkshih@realtek.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Michael Straube <straube.linux@gmail.com>,
 Peter Robinson <pbrobinson@gmail.com>,
 Bitterblue Smith <rtl8821cerfe2@gmail.com>, luka.gejak@linux.dev
Subject: =?US-ASCII?Q?RE=3A_=5BPATCH_v2_11/11=5D_wifi=3A_rtw88=3A_run_th?=
 =?US-ASCII?Q?e_RTL8723BS_association_register_sequence?=
In-Reply-To: <c697b23e723f4cab875e2c01fe6defc0@realtek.com>
References: <611b495996b74b278bfd769a9c045582@realtek.com> <20260730074504.19725-10-luka.gejak@linux.dev> <c697b23e723f4cab875e2c01fe6defc0@realtek.com>
Message-ID: <BE0CAC76-A3CD-413A-9276-E2A1A2138F10@linux.dev>
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

On July 31, 2026 2:48:45 AM GMT+02:00, Ping-Ke Shih <pkshih@realtek=2Ecom> =
wrote:
>
>luka=2Egejak@linux=2Edev <luka=2Egejak@linux=2Edev> wrote;
>> On 27/07/2026 09:33, Ping-Ke Shih wrote:
>> [=2E=2E=2E]
>> On reducing the rest: this patch is smaller in v3, but not as much as
>> I would like, and I want to be straight about why=2E Two things went:
>>
>>  - the beacon wait, once you made me measure it (see my reply on
>>    patch 10), which took struct rtw_auth_sync with it
>
>I see the result is positive, so this part can be removed, right?

Right, it is already gone in v3=2E

>> What is left is the vendor start_clnt_join() register programming
>> itself: the BSSID-scoped receive filter, the response and basic rate
>> set from the BSS rate elements, preamble and slot time, TSF update, the
>> retry limit and the security config=2E I have removed these individuall=
y
>> on hardware and association fails or the AP drops us shortly after,
>> which is why they are still here rather than because I have not tried=
=2E
>
>I think you can implement these by chip->ops->mac_init(rtwdev);

Before answering that I have to correct the sentence you are replying
to=2E It is wrong=2E

I ran the experiment you asked for below, and the association register
sequence is not needed at all=2E What I told you was bring-up era data
that I repeated without re-measuring=2E That is the same mistake you
caught with the beacon wait, and I should have re-tested before
asserting it a second time=2E

>So the order of patches might be
>1=2E add specific handlings for RTL8723BS for common flow
>2=2E add RTL8723BS (but not enable right now)
>3=2E add *very* specific handlings for RTL8723BS for common flow
>   Here *very* means a lot of difference like you mentioned=2E
>   But if without this part, the RTL8723BS still can work (not perfect),
>   the step 4 can go ahead with step 2=2E Need your experiments to
>   confirm=2E
>4=2E enable RTL8723BS by Kconfig/Makefile

Confirmed, and it is better than "not perfect": I measured no
difference at all=2E Step 3 disappears=2E

I reverted the whole patch, 440 lines, which is the join sequence, the
chip_ops::prepare_tx callback, the six sites in
rtw_ops_bss_info_changed() and both sites in rtw_ops_set_key()=2E All
testing is WPA2-PSK/CCMP against one AP=2E

                        with patch    without
  scans seeing AP       23/24         18/18
  associations          8/8           6/6
  TCP up / down         21=2E8 / 38=2E9   18=2E6 / 39=2E0 Mbit/s
  UDP up / down         25=2E0 / 40=2E0   25=2E0 / 40=2E0, 0% loss both
  rtw88 errors          0             0

The uplink figures need a caveat, because the two columns were measured
on different days and uplink on this band drifts by several Mbit/s from
one day to the next, so 21=2E8 against 18=2E6 is not a comparison I can
stand behind=2E I repeated it as a paired test instead: ten alternating
cycles in a single session, rebuilding and reinstalling the driver each
time, five with the full series and five with all four patches
reverted, so both see the same air=2E

  full series      19=2E0 Mbit/s mean over 10 runs, 18=2E7 to 19=2E4
  four reverted    19=2E2 Mbit/s mean over 10 runs, 18=2E9 to 19=2E6

There is no uplink cost=2E Downlink was never lower without the patches
either, 38=2E9 with against 39=2E0 and 42=2E9 without, so the wider spread=
 in
the tables above is the environment rather than the code=2E

Then a 5 minute stability run on the ablation: ping 1495/1495 at 0%
loss, reconnects 15/15, link cycles 5/5, module reloads 3/3, scans
under traffic 5/5, idle power save wake 0% loss, 24 rekeys completed,
zero deauth, zero rqpn relatch, zero SDIO errors, no warnings, peak TX
150 Mbit/s=2E

The reconnects and the rekeys are the point: the join sequence ran from
mgd_prepare_tx() on every authentication, so 15 reconnects exercise
exactly the path it lived on=2E

Since that patch is what added the chip tests to mac80211=2Ec, dropping
it takes that file from 8 chip tests to 0, and three of your review
points on the other mail become unnecessary rather than needing rework=2E

Your instinct was better than my evidence, so I applied it to the
coexistence patches as well, whose justification came from the same
period=2E Reverting those too, together with the GNT_BT command whose
only caller they were:

  scans 18/18, associations 6/6, TCP 18=2E0 up / 42=2E9 down, UDP 25=2E0 u=
p
  and 40=2E0 down both at 0% loss, 0 errors=2E Same 5 minute soak, same
  result: 15/15 reconnects, 5/5 scans under traffic, 3/3 reloads=2E

So the second correction: the commit message on the scan antenna
workaround claims the site survey does not hear the AP reliably without
it=2E That is also wrong=2E It scans 18/18 without it=2E

One thing worth stating precisely, because it looks like a gap and is
not=2E Those two coex patches are gated

  if (!rtw_is_8723bs(rtwdev) || !rtwdev->coex=2Estat=2Ebt_disabled)
          return false;

so they only ever execute when bt_disabled is set, which was the case
throughout=2E That is their entire scope, not a subset of it=2E

That leaves prep at six patches:

  1 add the RTL8723B chip type and SDIO helper
  2 rx: mark zero length packets on RTL8723BS
  3 fw: fix the reserved page upload on RTL8723BS
  4 sdio: track free TX pages and OQT credits for RTL8723BS
  5 sdio: set up RX aggregation and interrupts for RTL8723BS
  6 sdio: add TX back-pressure and retry on page starvation

and no chip tests left in mac80211=2Ec or coex=2Ec=2E What remains is one =
in
rx=2Ec, one in fw=2Ec and eleven in sdio=2Ec, all of which you have alread=
y
said are fine inline=2E

With step 3 gone your ordering collapses to prep, then the chip driver,
then Kconfig/Makefile, then MAINTAINERS=2E Would you rather have that as
one series of nine patches, or keep the current split with prep sent
first? I am happy either way; one series removes the "wait for prep to
land" coordination=2E

One detail for the ordering: a few register defines currently sit in
the patches being dropped but are used by rtw8723b=2Ec, so they move into
the chip support patch=2E BIT_AMF is used by its WLAN_RCR_CFG, and
REG_PWR_DATA, BIT_EEPRPAD_RFE_CTRL_EN, REG_RFE_CTRL_ANT_SW,
BIT_RFE_CTRL_ANT_SW_SEL, REG_RFE_CTRL_ANTA_SRC and
BIT_BT_SEL_BY_WIFI_8723B by its own coexistence code=2E

REG_BB_SEL_BTG_8723B goes away entirely rather than moving=2E Its only
users were the coex patches being dropped, and it duplicates
REG_BB_SEL_BTG in rtw8723x=2Eh at the same address, which is the one
rtw8723b=2Ec actually uses=2E

Best regards,
Luka Gejak

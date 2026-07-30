Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 379C5384228
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 07:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785397542; cv=none; b=c2POQOOLpKr603bSfatK06b2DPQXPqDdnYDnvLMsEFFqA9EXR9rx1Ok6QJeS6rpbNLwlKfQlmC8Cs224f7jbKMNMxx4IybAu8Hhgt+8hvRuuoOf9CTnjN+VeoZfHsP6fq20fnIRusXd699z5GmeB7rkHqXFxpjcolt3OBZrY6wI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785397542; c=relaxed/simple;
	bh=ilqpXRs5Gjp1XUz5n3vylnMuOeFMC/i10oudBSB0S/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EQYewHDg5XTNkSDz2WiMD90+BKAfcDJ1MSxpgzSzZpaT6Zf0sI1AGHhXW9WS2f146nNSkMv7VgSpH2vAje9GVLm520YJSN1HLYMmFRfduvNBHX9/ObTpoYYUEOCobAZ9R115EVkXkfXXvPVdL97uEE0Mtj07t9I+pl/qRCEJUSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=XCKkVD0p; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="XCKkVD0p"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785397538;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aZ5q2fkJqoaxU2lkWLYbtgThjQU1UM6dku1EOqBjxoc=;
	b=XCKkVD0p0/BBq2J4YSY8whVp+L8+/psuFYQQfME1S60H+799474b6HODlVQ50oa3JTq90b
	f6Z9mwW3OWXNwNCmQZzA/BhbJv8bE8pEH/1W79vw4HsFlYg3wzTqj2LYwK2JPKN0wj8N8i
	vGUaJDvTXlEea0stka+V8ElnLcyGi20=
From: luka.gejak@linux.dev
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: Luka Gejak <luka.gejak@linux.dev>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Michael Straube <straube.linux@gmail.com>,
	Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>
Subject: Re: [PATCH v2 05/11] wifi: rtw88: coex: add the RTL8723BS scan antenna workaround
Date: Thu, 30 Jul 2026 07:44:58 +0000
Message-ID: <20260730074504.19725-4-luka.gejak@linux.dev>
In-Reply-To: <c04cb1048e1940b1bc63dd68732998d8@realtek.com>
References: <c04cb1048e1940b1bc63dd68732998d8@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Luka Gejak <luka.gejak@linux.dev>

On 27/07/2026 07:58, Ping-Ke Shih wrote:
>> +/* 8723BS SDIO WiFi/BT coexistence antenna handling. On BT-disabled boards the
> 
> comment style.

Fixed here and everywhere else in the series.

>> +#define REG_8723BS_BT_COEX_CTRL                0x0039
>> +#define REG_8723BS_BB_ANT_CFG          0x0930
>> +#define REG_8723BS_BB_ANT_CFG1         0x0944
>> +#define REG_8723BS_BB_ANT_BUF          0x0974
>> +#define RTW8723BS_COEX_H_WLAN_ACTIVE   0x1800101b
> 
> define these in reg.h

Done for the registers. 0x0974 already existed as REG_RFE_CTRL_E, so I
use that. The other three are now

  #define REG_PWR_DATA		0x0038
  #define BIT_EEPRPAD_RFE_CTRL_EN	BIT(11)
  #define REG_RFE_CTRL_ANTA_SRC	0x0930
  #define REG_RFE_CTRL_ANT_SW	0x0944
  #define BIT_RFE_CTRL_ANT_SW_SEL	GENMASK(1, 0)

0x0039 is the second byte of REG_PWR_DATA and the bit the vendor sets
there is bit 11 of the register, which rtl8xxxu calls
PWR_DATA_EEPRPAD_RFE_CTRL_EN, so I used the same name with rtw88's
BIT_ prefix. 0x0930 is rfe_ctrl_anta_src in the vendor PHY register
header. 0x0944 has no vendor name I could find, so I named it after
what the write does; happy to take a better one if you have it.

0x1800101b I left in coex.c: it is a value written to
REG_BT_COEX_TABLE_H, not a register, and coex.c already keeps its other
table values inline. Say the word and I will move it.

>> +/* Write BB_SEL_BTG, retrying once with SYS_FUNC BB reset if the first
> 
> With the given name, this comment seems not necessary.

Removed.

>> +       if ((sys_func_before & (BIT(0) | BIT(1))) != (BIT(0) | BIT(1)))
>> +               rtw_write8_set(rtwdev, REG_SYS_FUNC_EN, BIT(0) | BIT(1));
> 
> Use given names for BIT 0/1.

Now BIT_FEN_BB_GLB_RST | BIT_FEN_BB_RSTB. The same open-coded sequence
appeared twice, so it is factored into rtw_coex_8723bs_enable_bb().

>> +static u32 rtw_coex_8723bs_reassert_pta_ant(struct rtw_dev *rtwdev)
> 
> Just call rtw_coex_8723bs_write_bb_sel_btg() ?

Dropped. rtw_coex_8723bs_write_bb_sel_btg() now takes no value and
computes the PTA path itself, since that was the only value ever
written.

>> +static void rtw_coex_8723bs_fw_gnt_bt_low(struct rtw_dev *rtwdev)
>> +{
>> +       if (!rtw_coex_8723bs_bt_disabled(rtwdev))
> 
> Please review your calling path. I think callers should ensure RTL8723BS
> before calling. (But here needs additional condition bt_disabled though)
[...]
>> +       if (!rtw_is_8723bs(rtwdev))
> 
> Caller check this already.
[...]
>> +       if (coex_stat->bt_disabled)
> 
> It looks like callers check this already.

All of these are gone. There are now exactly two entry points from the
common flow, rtw_coex_8723bs_scan_notify() and
rtw_coex_8723bs_connect_notify(), which test the chip and bt_disabled
once and return true when they have handled the notification.
Everything below them assumes both. rtw_coex_8723bs_bt_disabled() is
gone with them.

While doing that I found rtw_coex_8723bs_set_cck_pri() was only ever
called with high=true, so the argument and its dead else branch are
removed too.

> I wonder how you can make this workaround? There are so many arguments.

It is halbtc8723b1ant_SetAntPath() for the wifi-only / BT-off case,
plus the vendor's non-connected coex table and PS-TDMA type 8. Every
register write in the function maps one to one onto a vendor write in
that path; I did not invent any of the values. I then removed them one
at a time on hardware to check each was actually load bearing, which is
how the ones below went.

>> +                       req.op_code = BT_MP_INFO_OP_SUPP_VER;
>> +                       rtw_fw_query_bt_mp_info(rtwdev, &req);
>> +                       req.op_code = BT_MP_INFO_OP_PATCH_VER;
>> +                       rtw_fw_query_bt_mp_info(rtwdev, &req);
> 
> These two are debug purpose. When you cat debugfs, it will try to query the
> version, won't it?
> 
>> +                       rtw_fw_query_bt_info(rtwdev);
> 
> It seems to be called at initial. Is it necessary?

You are right on both counts, all three are removed.

Measured over 10 cold module reloads, three scans each, with and
without them:

  with:     24/24 scans saw the target AP, 8/8 associations
  without:  29/30 scans saw the target AP, 10/10 associations

The single miss is one scan pass not catching a beacon, not a
regression. The pre-auth rtw_fw_query_bt_info() in patch 06 went the
same way, together with two of the three repeated PS-TDMA H2Cs there.

> Since RTL8723BS does special handle, just move all into a function, but put
> in common flow.

Done, that is rtw_coex_8723bs_scan_notify() above.

>> +void rtw_coex_8723bs_scan_workaround(struct rtw_dev *rtwdev);
> 
> Just static no need to export.

Static now, and the coex.h declaration is gone.

Best regards,
Luka Gejak

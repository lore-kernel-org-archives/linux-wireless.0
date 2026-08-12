Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EED17336881
	for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2026 07:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786521190; cv=none; b=mith9Wf+eujQBgGj1VAyHCgHPcmasu3WQNRboseSRCeR7utFGEV7cW4jlcjxRv5qXsDnzdo94d3sY9fhzj/EUyV/tKv+khzEL6fmY2/JIxZ7Btj/5sMAfr5QI46Htf9fyEphLJ7eH3f/mdyHFojLhsF+bCs6v7QhOSmEq18IcKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786521190; c=relaxed/simple;
	bh=xuH8wOsfox/c07DyssW1HKJDd+Z1Jkc1ttgGn9LUngM=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=OKZ94+O1tmtjFYL+hI6ircBS+431agph5nN04OdC6tPvZBjgSjJa3XO9wtyovTVAaoBRWE7a7jQmj6tfCwo6cFlVammJX5Y1qLwPwv0eZjREiNS1Oy4tuLO/bIKo9Hko85kVvdWAahMUNN2rUY3yuzvsqe9NP8eTOpzaigBd7/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=hXKaIYse; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="hXKaIYse"
Date: Wed, 12 Aug 2026 09:52:56 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786521181;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xuH8wOsfox/c07DyssW1HKJDd+Z1Jkc1ttgGn9LUngM=;
	b=hXKaIYseCI5Ju+DM2oNbKNh8qBi36inXESKw1vjhoYazyPyTPK9B9Qssafn0Uv3qsTMjb3
	mO6b0kIaNrRfCsTsTDM1DGV8v0ganUR9A4zUYJYlDrxuE2vqtWwGMmX0mgg+TgsWGkrcyr
	d+i2bpAROxp+ZUAPeUB2vHX872PU3n0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Luka Gejak <luka.gejak@linux.dev>
To: Ping-Ke Shih <pkshih@realtek.com>,
 "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Michael Straube <straube.linux@gmail.com>,
 Bitterblue Smith <rtl8821cerfe2@gmail.com>,
 Peter Robinson <pbrobinson@gmail.com>,
 Hans de Goede <johannes.goede@oss.qualcomm.com>, luka.gejak@linux.dev
Subject: RE: [PATCH v3 0/5] wifi: rtw88: preparations for RTL8723B/RTL8723BS
In-Reply-To: <9f96f4a479f64ef384c76c3b1f71b2a4@realtek.com>
References: <20260804065425.17364-1-luka.gejak@linux.dev> <A850D677-5DD9-4626-9DAB-1C62F20E292F@linux.dev> <9f96f4a479f64ef384c76c3b1f71b2a4@realtek.com>
Message-ID: <57719CE4-BEE4-4A1E-B760-DFFD04FF865C@linux.dev>
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

On August 12, 2026 2:38:23 AM GMT+02:00, Ping-Ke Shih <pkshih@realtek=2Ecom=
> wrote:
>
>Luka Gejak <luka=2Egejak@linux=2Edev> wroet:
>> On August 4, 2026 8:54:20 AM GMT+02:00, luka=2Egejak@linux=2Edev wrote:
>> >From: Luka Gejak <luka=2Egejak@linux=2Edev>
>> >
>> >This is the first of two series adding support for the Realtek RTL8723=
B
>> >802=2E11n chipset and its RTL8723BS SDIO variant to rtw88=2E It contai=
ns
>> >only the changes to the shared rtw88 core that the chip driver depends
>> >on=2E The chip itself, the build glue and the MAINTAINERS entry are a
>> >second series=2E
>> >
>> >v1 had 19 patches, v2 had 11, this has 5=2E
>> >
>>=20
>> =2E=2E=2E
>>=20
>> Hi Ping-Ke,
>>=20
>> I have sent a v4 that supersedes this series, before you review v3, so
>> you do not spend time on this one=2E As you suggested, I am noting it h=
ere
>> on the v3 cover=2E
>
>Thanks for the notification, and sorry for the late=2E I hope I can revie=
w
>v4 this Friday if no urgent tasks interrupt me=2E
>

No need to apologise=2E Before you spend time on it: please skip patch 4/7
("fw: handle the RTL8723BS management TX reports")=2E I am dropping it in
v5=2E Your question below is what sent me back to the hardware, and the
answer is that the patch cannot be doing what its commit message claims=2E

>>=20
>> v4 re-adds two patches that were dropped in v2, both on the TX report a=
nd
>> leave-LPS paths=2E Testing on slower ARM SDIO hosts, Peter Robinson on =
the
>> RFC and another tester on a Rockchip RK3288 board, reproduced "failed t=
o
>> get tx report from firmware"
>
>This makes sense for slower platform=2E
>
>> and "firmware failed to leave lps state",
>
>Does this only occur on "slow" platform? Unless a C2H event was handled
>slowly? I'll review the patch and add comment there=2E
>
>Ping-Ke
>

It is not a C2H handling issue on this chip, and that is the problem with
the patch=2E The RTL8723BS v41 firmware does not advertise
FW_FEATURE_LPS_C2H: the feature word in the firmware header is 0x00007df0,
which has FW_FEATURE_SIG clear, so __update_firmware_feature() sets
fw->feature to 0=2E rtw_fw_leave_lps_check() therefore takes the
__rtw_fw_leave_lps_check_reg() branch and polls REG_TCR=2E Nothing ever
waits on rtwdev->lps_leave_check, so the part of my patch that stops
completing it on a 0x32 event changes nothing at all=2E

The other half does not hold up either=2E With the driver instrumented, 93
TX reports over three scans arrive as C2H id 0x03, and no event arrives
with a top level id of 0x12 or 0x32=2E Bitterblue Smith made this point on
v1, that 0x12 and 0x32 are payload bytes of C2H_CCX_TX_RPT rather than
C2H ids=2E The hardware agrees with him=2E

The tester's report does not require the patch either=2E He saw "failed to
get tx report from firmware" easily on the unfixed branch, and "firmware
failed to leave lps state" only sometimes; with both patches applied the
lps warning did not appear=2E An intermittent warning not appearing in one
run does not establish much on its own=2E

So that warning is still unexplained=2E Since the check is a REG_TCR poll
with a 100 ms budget, a slow SDIO host missing that window is the obvious
candidate, but I have not reproduced it: my only board is a fast x86
host=2E A branch carrying patch 3 alone is out with the tester now=2E If a
poll window turns out to be the cause I will send it as a separate patch,
with the measurement behind it, rather than folded into this one=2E

One detail from the same report that is worth separating out: with both
patches applied, the tx report warning still returns after a
"systemctl restart wpa_supplicant@wlan0=2Eservice"=2E That looks like the
generic case where a management frame is still awaiting a report when the
link tears down, since the tx_report queue is only purged at deinit and
not on disconnect=2E That is not specific to this chip and I am not
addressing it in this series=2E

So the slow host improvement in v4 comes from patch 3 alone=2E It extends
the 2500 ms timeout from commit c80788f7c5ae ("wifi: rtw88: increase TX
report timeout to fix race condition"), which you acked for the
RTL8723DU, to the RTL8723BS for the same off channel scan race, and the
slow host reports match that mechanism=2E v5 will be this series with
patch 4 removed, so six patches, and the cover letter will say that one
patch was restored rather than two=2E

Best regards,
Luka Gejak

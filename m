Received: from mta1.migadu.com (out-147.mta1.migadu.com [95.215.58.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A843A43DEC8
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 21:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790200238; cv=none; b=CVF6jPrKnx8kOnnDWruq5VGIRKvRqyL+WLjJb1+9itfY5lv042Nozbu/zhTxPywJhaXqOMW+/hcwlyyYbGuqT6Pt9ZaXtHeyAvLuCzk8ViQpHSCkTZDNdE/5kMjrYS3NqjfBHYqNCC08v4hvF6+kKeDvJjwuE4uSo68n9WBjdGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790200238; c=relaxed/simple;
	bh=HPfVi3y1gax+ff5umcyzIricIySLtDF7Qf7jPDLvjBk=;
	h=Mime-Version:Content-Type:Date:Message-Id:To:Cc:Subject:From:
	 References:In-Reply-To; b=CobaU9NI8AQ6WxCv4l8mthnrjK/BB54d0eAhtY4/P7rp1HNh+J3fU+UYQPB7h2KuI/xGM9/H5J0THqCuD8AbB+tV8OdV9FBIp4AiTtGOhrSriTL/swT7CabckrgSlpW1TZUwg4Fgw/bh2j2wAN84/YWVwUH82fVedPwoG5Ictpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RoIVSPD+; arc=none smtp.client-ip=95.215.58.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RoIVSPD+"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=HPfVi3y1gax+ff5umcyzIricIySLtDF7Qf7jPDLvjBk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790200233; v=1; x=1790805033;
 b=RoIVSPD+PbAQA46zhAMBG7rTAtMe+w3VxsYuNX+fBAnc/WV5+MmNWhlMNyiGcP0S03Ypykx+
 5lpb0Xf4pXoMOmk7LhOY4cyIfiIlhBkvyG5uLp19j4+/WSTfT/KxbZN9kQ2dq+trOdFrhCLE9pA
 +h1GVCS2pBKwblqjPr5DWPws=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id c37ad1e32183d01a;
	Wed, 23 Sep 2026 21:50:13 +0000
X-Mizu-Trace-ID: c37ad1e32183d01a
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 23 Sep 2026 23:50:11 +0200
Message-Id: <DLN10FU8L1PQ.3NK0M6NVQ3Y53@linux.dev>
To: "Ping-Ke Shih" <pkshih@realtek.com>, "Luka Gejak" <luka.gejak@linux.dev>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Michael
 Straube" <straube.linux@gmail.com>, "Peter Robinson"
 <pbrobinson@gmail.com>, "Bitterblue Smith" <rtl8821cerfe2@gmail.com>
Subject: Re: [PATCH v3 3/6] wifi: rtw88: 8723b: add the RTL8723B chip driver
From: "Luka Gejak" <luka.gejak@linux.dev>
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <20260921154347.82317-1-luka.gejak@linux.dev>
 <20260921154347.82317-4-luka.gejak@linux.dev>
 <39da13e5cdd840f5a5ab86ded478d07c@realtek.com>
In-Reply-To: <39da13e5cdd840f5a5ab86ded478d07c@realtek.com>

On Wed Sep 23, 2026 at 10:30 AM CEST, Ping-Ke Shih wrote:
> Luka Gejak <luka.gejak@linux.dev> wrote:
>> Add the Realtek RTL8723B 802.11n chip driver: the chip operations, the
>> power sequences, the efuse layout, the RF and IQ calibration, and the
>> chip specific coexistence handling.
>>=20

Thanks for the review. Everything that could be turned into a change is
in v4, and six of your points are worth an answer as much as a change,
so here they are.

>> +#include <linux/unaligned.h>
>> +#include "main.h"
>> +#include "coex.h"
> [...]
>> +#include "tx.h"
>
> In increasing alphabet order.

The list is already in increasing alphabetical order after main.h, and
main.h cannot be sorted into place. The other rtw88 headers have no
includes of their own and are written expecting main.h to be first: it is
what brings in struct rtw_dev and even BIT() and GENMASK(). With mac.h
ahead of main.h the build stops after 179 error lines, the first of them

  'struct rtw_dev' declared inside parameter list will not be visible
  outside of this definition or declaration
  implicit declaration of function 'GENMASK'
  passing argument 1 of 'rtw_set_channel_mac' from incompatible pointer
  type

I tried the sort and reverted it. A strict order needs main.h added to
those headers first. I can send that as a separate patch ahead of this
series, but I would rather not fold a shared header change into the chip
driver.

>> +#define MASK_NETTYPE   0x30000
>> +#define _NETTYPE(x)    (((x) & 0x3) << 16)
>> +#define NT_LINK_AP     0x2
>
> The PORT_SET_NET_TYPE in rtw_vif_port_config() does similar thing
> relying on static const struct rtw_vif_port rtw_vif_port[].
>
> Is that not suitable for RTL8723B? If so, should the common flow
> avoid RTL8723B?

It is suitable, and the common flow does not need to avoid RTL8723B.
PORT_SET_NET_TYPE writes the same field with the same value:
rtw_vif_port[0].net_type is address 0x0100 with mask 0x30000, which is
REG_CR bits 17:16, and rtwvif->net_type is RTW_NET_MGD_LINKED, 2, the
value NT_LINK_AP carried.

Only the timing differs, and there the common flow is the better one.
rtw_ops_add_interface() sets net_type from the interface type,
RTW_NET_NO_LINK for a station, and the association path moves it to
RTW_NET_MGD_LINKED, writing REG_CR after both. The chip local call ran
during mac_init and forced the linked value before there was a link,
and the core's write replaced it a moment later in any case.

So v4 drops rtw8723b_init_network_type() with MASK_NETTYPE, _NETTYPE()
and NT_LINK_AP, and the chip relies on rtw_vif_port[] like the others.
No other rtw88 chip defines a net type value of its own.

>> +       /* Override the default rcr filter for 8723B */
>> +       rtwdev->hal.rcr =3D WLAN_RCR_CFG;
>
> Why? The default value doesn't work to RTL8723B?

Two things say it does not.

hal.rcr is not only written at init. fw.c clears and restores
BIT_CBSSID_BCN in it around the beacon filter, and mac80211.c toggles
BIT_AM, so whatever is left there has to keep those bits.

And this is not a private filter. It is the RCR that rtw8723x_mac_init()
writes for the whole 8723x family, 0x700060ce, with BIT_APP_FCS added.
The generic default is a different set: it has BIT_PKTCTL_DLEN and lacks
BIT_CBSSID_DATA, BIT_CBSSID_BCN and BIT_AMF, so it drops exactly the bits
fw.c manipulates on this chip.

BIT_APP_FCS has to be set because rtw88 advertises RX_INCLUDES_FCS for
every chip and the shared 8723x value has bit 31 clear; without it
mac80211 trims four bytes of real frame data. v4 says this at the
assignment.

>> +       rtw8723b_init_adaptive_ctrl(rtwdev);
>> +       rtw8723b_init_edca(rtwdev);
>> +       rtw8723b_init_retry_function(rtwdev);
>
> So RTL8723B is very different from existing chips?

No, and the siblings write the same registers with the same values.

rtw8703b_phy_set_param() writes REG_SPEC_SIFS, REG_MAC_SPEC_SIFS, REG_SIFS
and REG_SIFS + 2 with the same 0x100a, ACKTO is 0x40 in both, and
REG_RETRY_LIMIT uses the same 0x3030 in both. Its four EDCA registers are
the same magnitudes as here:

  8703b  0x002FA226 VO  0x005EA324 VI  0x005EA42B BE  0x0000A44F BK
  8723b  0x002FA226 VO  0x005EA324 VI  0x005EA42B BE  0x0000A44F BK

rtw88xxa.c writes REG_RRSR with the same 0xfffff / 0xffff1 pair used here,
and REG_RESP_SIFS_CCK and REG_RESP_SIFS_OFDM are the pair that only this
chip and 8822c write. So I read the three helpers as the family pattern
rather than as something chip specific. Say the word if you would rather
have them inlined into rtw8723b_phy_set_param() the way 8703b has them;
that is a smaller diff.

>> +static bool rtw8723b_sdio_needs_rx_path_fix(struct rtw_dev *rtwdev)
>
> What does it mean?
>
> In many places using this function are not RX path.

Right, the name hid what it is, and it is a test the preparation series
already provides. The function gates the SDIO only register work: the PAD
mux restore in post_enable_flow, the path control save and restore around
IQK, and the trailing re-assert in set_channel. v4 drops the local helper
and calls rtw_is_8723bs() at those seven places, which is what rx.c, tx.c
and sdio.c already use.

One more, where the review asked for a change that was already there.
The declarations in rtw8723b_reassert_rx_path() that you marked for
reverse X'mas order are already longest first, three u32 lines followed
by two u8 lines, and they are the same in the sent v3 and in v4. If you
had a different order in mind, tell me which and I will apply it.

I re-ran the hardware validation on this exact tip after these changes.
The suite and the soak both pass: association, WPA2, DHCP, throughput,
latency, scans under traffic, 20/20 reload/reassociate, link cycles and
reconnects, with no error, TX-report, H2C, LPS or lockdep lines in dmesg,
and no regression against the branch that was validated before.

Best regards,
Luka Gejak

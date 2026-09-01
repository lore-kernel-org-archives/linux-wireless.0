Received: from mta0.migadu.com (out-30.mta0.migadu.com [91.218.175.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 373524756DA
	for <linux-wireless@vger.kernel.org>; Tue,  1 Sep 2026 13:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788270570; cv=none; b=Wv9Hi2oOs728xdt7zssw40+iMye+WW7Xsneamg5ll4/Y7x7GMA96DPvDjz4Mrufzuw2cn/XDaCm83RfSDCy4cLr1/oYgtcwRwlCjMzF8RXriufCEPN9L8reubpEu7eeZiJx6kmSE1zOVT7As+msp+AOjcWGg+vQkxo/g54tqGyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788270570; c=relaxed/simple;
	bh=8QFSnlpySFykmoc6yP1oqqE80w3/ep3oZQ4c2DH1o2c=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=sjRXfZyE8ERza60niO+FErBvCopnRs1qigR+RUdzhwdi2ehzXjtWQezLkg35gpYn7CdZ07DbRp5Rosfz6A/s/r0SkSqANWwUCugqpr+p5aiwmBdSlVR0Lith/v5JZkTysoyqTNHFhwsEIQnatszKV+CWdkORqwMT5rtJrMz8mKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=AsrPG1w7; arc=none smtp.client-ip=91.218.175.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="AsrPG1w7"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=8QFSnlpySFykmoc6yP1oqqE80w3/ep3oZQ4c2DH1o2c=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788270560; v=1; x=1788875360;
 b=AsrPG1w71eVQf+Cq92swImB4THJWhJultgQ1RDob6Kr/BdyeO2me9iI6LsDTQvhiWrmeIseR
 Qns4D0Yr44IaiLAKEaRPBNnpCKtLfQDpWIyBw3R2j7P1/71X8gx81HUa05BMZitfCUAlMoDBDwR
 JJ++t3P6vj4xTlj/G9w0+JwA=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 7ef7f32c45b88611;
	Tue, 01 Sep 2026 13:49:19 +0000
X-Mizu-Trace-ID: 7ef7f32c45b88611
X-Migadu-Flow: FLOW_OUT
Date: Tue, 01 Sep 2026 15:49:13 +0200
From: Luka Gejak <luka.gejak@linux.dev>
To: Ping-Ke Shih <pkshih@realtek.com>,
 "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Michael Straube <straube.linux@gmail.com>,
 Bitterblue Smith <rtl8821cerfe2@gmail.com>,
 Peter Robinson <pbrobinson@gmail.com>,
 Hans de Goede <johannes.goede@oss.qualcomm.com>, luka.gejak@linux.dev
Subject: RE: [PATCH v8 0/6] wifi: rtw88: preparations for RTL8723B/RTL8723BS
User-Agent: Thunderbird for Android
In-Reply-To: <f1454e9c2add47b2b01a0adb8233455f@realtek.com>
References: <20260825163314.1590-1-luka.gejak@linux.dev> <4866D935-FCC8-4F24-9C05-8678DCB22533@linux.dev> <f1454e9c2add47b2b01a0adb8233455f@realtek.com>
Message-ID: <B2A0C047-C517-4AB4-BD6E-3EC6E9DA23EB@linux.dev>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Ping-Ke,
On August 31, 2026 4:23:48 AM GMT+02:00, Ping-Ke Shih <pkshih@realtek=2Eco=
m> wrote:

The probe_wait_ms test you suggested has run, nine hours in the tester's
poor signal environment=2E At 2000 ms he saw one "Failed to send nullfunc
=2E=2E=2E disconnecting"=2E At 500 ms it was one every twenty to forty sec=
onds=2E
Same environment, same driver=2E

The reports are late rather than missing:

  txrpt: nullfunc sn=3Df0 queued
  wlan0: Failed to send nullfunc to AP after 500ms, disconnecting
  txrpt: nullfunc sn=3Df0 acked after 810ms

The frame was acknowledged and the link was alive=2E Nullfunc reports run
400 to 1000 ms on this chip when the link is poor, against 0 to 20 ms
for management frames on the same hardware, so it is firmware retry
time=2E

That also rules out the timeout path as the mechanism=2E It fires 2500 ms
after the last enqueue, well after mac80211 has given up, and a build
that handed the frames back as not acked instead of dropping them made
no difference=2E The sequence number aliasing I raised does not show up
either: every instance had one frame in the queue=2E

So there is nothing here for the driver to fix, and probe_wait_ms is not
something a driver can set=2E I am not proposing anything for it=2E

> But I feel this case, using ieee80211_purge_tx_queue() is equivalent?

Not equivalent=2E ieee80211_purge_tx_queue() calls ieee80211_free_txskb(),
which calls ieee80211_report_used_skb() with dropped =3D true: that
settles the airtime accounting and frees the skb properly, but never
reaches ieee80211_sta_tx_notify()=2E Only ieee80211_tx_status_*() does=2E =
It
fixes the ownership bug and tells the connection poll nothing, which
given the above does not matter=2E

Still worth doing on its own=2E I will send it separately, no chip
condition=2E

Best regards,
Luka Gejak

Received: from mail-lf2-f13.google.com (mail-lf2-f13.google.com [74.125.229.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7906638D3F4
	for <linux-wireless@vger.kernel.org>; Sat, 19 Sep 2026 20:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.229.205
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789850666; cv=pass; b=BhHf/E4J/rVKA2nKDbxElVZ7aTWe9ru1qh6gyBVSnX4+bZQWtg0s3Udcs/RfaN7TdouJSk9pE2ZKYVtyybFH/0CidFA4xvmnGq0xRGta/Lt8LCUiDuHDR9hO65rONbbcojozvy8Cs7qi3zrQZxFK+PPRZm2JvLfKdQNK8B3GX5U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789850666; c=relaxed/simple;
	bh=fG9smriL9Avld9eCP1TXKVywUYOjUPJA2/+J1iN2yo4=;
	h=MIME-Version:From:In-Reply-To:References:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JevCYmLj1HcMG8TqgaqJS1sgQNgJMuTR94G0O916WClvB9gWD/Mo6EGwJEdD8i9v1GX84GSeWhecnN+dFNWxp+tkWzCT8Fdv3xCyGXx3Im4A4LIWV2sSqaNLIqfDK7hA5cYcK7/uDu7TyLAem9/PAn9Sv+RA4bI2FukGv2Ckm4M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=khu.ac.kr; spf=pass smtp.mailfrom=khu.ac.kr; dkim=pass (1024-bit key) header.d=khu.ac.kr header.i=@khu.ac.kr header.b=PKmufmWN; arc=pass smtp.client-ip=74.125.229.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=khu.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=khu.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=khu.ac.kr header.i=@khu.ac.kr header.b="PKmufmWN"
Received: by mail-lf2-f13.google.com with SMTP id 2adb3069b0e04-5b8c9954ccbso401100e87.1
        for <linux-wireless@vger.kernel.org>; Sat, 19 Sep 2026 13:44:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789850660; cv=none;
        d=google.com; s=arc-20260327;
        b=QLlSeIxlcb6Sb9NY/cdCZW3EYtD4IkPb5kKnVD7v5QAOV+psF/4+WsIecdidAo5bWj
         b5sPHrGTKRzA+mbrfMxtM5mWk2g2SLErw2MhurbcU5TSmKd8/ask8jOuHT8hLApf7D57
         OcjqQJzW+rCnSdEBkfd+FVJ25MpJ/BRvO2o0YBP2Zrm2BvfwwOo9PEmvkAIatORqee3D
         fUt8wzcCThJyxzQs62tY9CeACe3WCcp7zAsykoF2P2WLj4gSkwWdXAQLL1fnfLMpnzeD
         eL7MN6lnRJhx8CZAbtrTkC/g5GQ+fcIVR+EROhRnG9WNLCQuhAvJuZZW77RNzhVWJCll
         GOcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:references:in-reply-to:from
         :mime-version:dkim-signature;
        bh=/eAHbyiob+ZcoG2VDBo0Mr54QnNvtez/xnycfesyT/I=;
        fh=n5v73YiJzxMAAE5ZePeLdT+lpUtZ9Qo7rWbrpoNNJIY=;
        b=nIhyBDDUNYS0Qi69iwH4FI+A78aIFmmXrjSDiB5tHOEuD/wFHg8C59WbvQ/rO/Rt47
         sjhXmKAc/+m97nV41FN4JS+7pCYFUV/0IbMhu55MLTaZSpA5E9OZ6vCjOaiWerRW+85x
         CWXqG1nhlmzEk7GYRLHSDK4i+Jw+u+qkJ7+OC4lzbBgDUAl3P3zGMzNQNvLdDEFRUb9D
         IYPZ4OYaVJ51jL+ytkBCFY/RxP/gCWLU9ztB7cNU4krgAqwDOGG4t7d/YkKwY8lE0f62
         ChQquhVEexB5WyC2OVCn0KEShpw8lwzsV43FkOPKP1FZ6S+mfcySP+DqTGrDt8QkHP3L
         whBg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=khu.ac.kr; s=google; t=1789850660; x=1790455460; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:references:in-reply-to
         :from:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/eAHbyiob+ZcoG2VDBo0Mr54QnNvtez/xnycfesyT/I=;
        b=PKmufmWNhHdeQrpoRwPoNWE2m3XxCk2td6ONe8CwZF/Io6lLaA1q8Ua7LWEG86SSrL
         s8N0GH/XiGjQGnp5zBYG9y1zATK5utuJ/L09FTNnvaLs2jsrjzyGeai5X+CES2GqA5oj
         fiuGRkP+bNNbwmEwzb4ImNBSscPKCXb2IvZrI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789850660; x=1790455460;
        h=content-type:cc:to:subject:message-id:date:references:in-reply-to
         :from:mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/eAHbyiob+ZcoG2VDBo0Mr54QnNvtez/xnycfesyT/I=;
        b=P5ldxg6jX1FPiA9dqANe+mE+1GZSN4ttp2Pw4ix01DLdJDSgvkMt8Zk/XpCpYbmeqK
         CfvmfnW64e3MiXssS4c3JxMx0XkUpr4NtonVZwy0z0Wo41DcGvggCTftRhvyjuKxuujX
         zvRPnwfwQXH29I4kM/ALtobqQ3dYujExi/Kk7acWWMJzx77/NwgTN0IhTDftzJLZ18kz
         KMshbNcqe1QGPRHh+NDZbQwOF3+iazHmtFfuW2/eT3kwQDItxCsWBDwYs/wAo4O5bs29
         gZjivaNj7D/4T8wqD0YvNVk5PvyelYRz5tHreLyEnuNX5FFKVy7bcuV8tTcZDE706ot1
         TWkg==
X-Gm-Message-State: AFuF++nxf0BEqDLtswyHognceippBy/Jkfoh/BoDHV6xc5whhLTpy5y5
	7G3W/eUpAb5hp7pU57svMTpKdietoM5At0QO9km9YXFkQiW9BLKvSACsUOwGHXul6pcudzluwKg
	rF0m7dkvwU/xZ9wQ2p1gH+BD8H5sFRsppJmruKz849Q==
X-Gm-Gg: AYBFou0Zt5bbf5pNkinttyFN33Dz2ZTVw64qYudpuuUtC+xeUzIWJH96LSjbRuT0rpF
	QLNYJ8iz447IvR4+P7k3k6C1Hc9F9zb3YO96zI2C/qk+1mTdJwII5+t/hZswsDvMQgIP9ozpN4n
	1GAX4PgfIkk5tzN3plHkwRmN14WwWgr35NwsvWbaYIfUVr9OkqomwsDolY1mQg8aI4HFn7xWiU4
	yiFCeh+y+KBhSm+UZwmQFhf+FM0jjF/9iORVBrnbyeniqEU+8exzekXJhLw4hUj0/CfyDQQdbcq
	i96H2XSkEIgjHpU9O2V/5X70R9etEu64zFxjTSb8qInaU9tTOGo=
X-Received: by 2002:a05:6512:3d1d:b0:5ae:c8da:6254 with SMTP id
 2adb3069b0e04-5b8c18298d5mr1778890e87.22.1789850659945; Sat, 19 Sep 2026
 13:44:19 -0700 (PDT)
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Sat, 19 Sep 2026 15:44:19 -0500
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Sat, 19 Sep 2026 15:43:33 -0500
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Received: from 77377267392	named unknown	by gmailapi.google.com	with HTTPREST;
 Sat, 19 Sep 2026 14:52:09 -0500
Received: from 77377267392	named unknown	by gmailapi.google.com	with HTTPREST;
 Sat, 19 Sep 2026 14:50:50 -0500
From: Kim Wooseok <5mghybrid@khu.ac.kr>
In-Reply-To: <ca51eb88df7b4e83993af73c2f1e26bb@realtek.com>
References: <20260913-codex-rtw-rx-v2-v2-0-f09c964e0b96@khu.ac.kr> <ca51eb88df7b4e83993af73c2f1e26bb@realtek.com>
Date: Sat, 19 Sep 2026 15:44:19 -0500
X-Gm-Features: AcwNN1XkXEzzYMBLWTykZJpCaY-PNLdTMEUvL7yvSz-NLAkhRJllSBnH9toq11w
Message-ID: <CAH1Bc_wo3PqWiqFcWZX9xB_+99=zHOdCD1VUg0R287Z2B4ESrw@mail.gmail.com>
Subject: Re: [PATCH rtw-next v2 0/4] wifi: rtl8xxxu: keep RX requests
 available across transient errors
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org, Jes Sorensen <Jes.Sorensen@gmail.com>, 
	Kalle Valo <kvalo@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Ping-Ke,

Here are the test conditions and results to help with the v3 review. I
have listed the 13 tests reported previously first, followed by the v3
results.

The tests used an RTL8192EU USB adapter on a Raspberry Pi. I adapted the
RX changes to the Pi's existing Linux 6.18.46 RT kernel so they could be
tested on the device.

For the recovery tests below, I checked that all 32 URBs were retained,
reception resumed without restarting the interface, and stop freed the
URBs. The RX completion counts are from after the injected errors ended.

1. clean-fixed-regression
   No faults: receive for 3 seconds, down/up, then receive for another 3
   seconds. PASS: 581 and 246 packets received, with no RX errors.

2. fixed-submit11-errno63-finite
   ENOSR completion errors x32 and EAGAIN submission failures x96. PASS:
   all faults were injected; RX then made 4,699 successful completions.

3. fixed-submit11-errno71-window
   EPROTO for 2 seconds (maximum 1,024), with up to 256 EAGAIN
   submission failures. PASS: 126 completion and 256 submission faults
   were injected; RX then made 5,227 successful completions.

4. fixed-submit11-errno75-finite
   EOVERFLOW completion errors x32 and EAGAIN submission failures x96.
   PASS: all faults were injected; RX then made 3,420 successful
   completions.

5. fixed-submit11-errno84-finite
   EILSEQ completion errors x32 and EAGAIN submission failures x96.
   PASS: all faults were injected; RX then made 4,243 successful
   completions.

6. fixed-submit12-errno62-finite
   ETIME completion errors x32 and ENOMEM submission failures x96. PASS:
   all faults were injected; RX then made 5,340 successful completions.

7. fixed-submit12-errno70-finite
   ECOMM completion errors x32 and ENOMEM submission failures x96. PASS:
   all faults were injected; RX then made 2,848 successful completions.

8. fixed-submit12-errno71-finite
   EPROTO completion errors x32 and ENOMEM submission failures x96.
   PASS: all faults were injected; RX then made 5,321 successful
   completions.

9. fixed-submit12-errno71-finite-control24
   EPROTO completion errors x24, with no submission faults. PASS: RX
   then made 4,921 successful completions.

10. fixed-submit12-errno71-finite-stop
   EPROTO budget 32 and ENOMEM budget 256; stop as soon as a retry is
   pending. PASS: stop saw two retry URBs after two completion faults
   and no submission faults; all RX URBs were released.

11. start-alloc8
   Fail the eighth RX URB allocation with ENOMEM. PASS: start returned
   failure and released its resources; the next start restored the pool
   and reception.

12. start-fatal8
   Fail the eighth RX submission with ENODEV. PASS: start returned
   failure and released its resources; the next start restored the pool
   and reception.

13. start-temporary
   Fail 64 RX submissions with ENOMEM beginning at startup. PASS: start
   succeeded, two delayed retry runs restored the pool and reception,
   and stop released the URBs.

V3 passed 52 tests: 42 from the main test plan, one matched-input
comparison, and nine first-start failure tests after a fresh module
load. Two interrupt-URB tests were not run because the RTL8192EU does
not use that path.

With the same 32-URB pool and 24 injected EPROTO completion errors, the
unpatched driver stalled with eight pending URBs and none in flight. V3
retained all 32 URBs and received 1,225 packets over 30 seconds without
restarting the interface.

Each of the nine first-start tests began before the driver had ever
started after probe. The first start failed and cleaned up; the next
start received packets normally.

Thanks,
Kim Wooseok

Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C88F04A13B6
	for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2026 17:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786641920; cv=none; b=pHIs4sAXq/aYGpFB/ImqrT4LwKp1r9cOdeQE8dK+UfAoDLOKVnLK1fxKTl7tqJycEEXyhEi/hn1cLMVYLzYJZ9jekotH8egWqk/LNNqy+bg/QsF4c4t5EojVjJ24wAP3Kx7fQ3c5aIDEMXQQXDtyqu+EtPZgy5WZIFDv/hTUMUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786641920; c=relaxed/simple;
	bh=aJwHFGAcXI8D3cLa13iYpUKgIVtpAb86nkrXf0RuNIs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=to3vi5v36q7z0m4f3Fvw0+mG5Ll8KmLUQN1I1O1H4VpOvbWPBgc/Vz3pK6jAcHixGXclWkZC8bodDc6AfbnT2+PNC62L56jcBLhYlLiDAkbNbY/W6+1FY6bSPxuUFp/6Y8jMUZ6u/ofDCvRfC47bCGkLH6JEomj2oEy7N6juexA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=KFaag13n; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=ItKR0d3e; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="KFaag13n";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="ItKR0d3e"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67DFTqPT3050661
	for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2026 17:25:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	F9XLCxOIm85fIIs/oaVmZtJIQ13dsGAPw34yNA1NUWg=; b=KFaag13nIa7JeA7Q
	2OOAsYwqqjYVQbFfYZ2VLTY86mEC/7ZkogH1w3geoqOBrPYmXccQONSrOZfOF7mE
	fouvpSakud2YuQH1tfhtatd648ECL0sNtWNoc/cfc7GgBwKBr77gLXkdBevKy4Jt
	vt/O1uYAm0aJppWiIZtkb3b2PA7aOKJWZ7KRm7bfFRW0nlTJDdPj9LjeitB4lE3M
	PTtykIoSZ1jy+i6JraDzTsfwXz6Q7mnlcNYh8XWlRFJo6cTSDKNcg9gZoX0GprJV
	zpBenw2rsKMy8ooEFqTyk4+jBoxxKClGFTJd99BhIhFp1UWZ66Gk/zRcIhzBUkEy
	v+myhQ==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g1fg3rxv8-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2026 17:25:14 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3931cd2e4cbso70299a91.2
        for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2026 10:25:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786641914; x=1787246714; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=F9XLCxOIm85fIIs/oaVmZtJIQ13dsGAPw34yNA1NUWg=;
        b=ItKR0d3eKZbrdKfFHWDygPfqeiiiKMfDCmy4zvNgL7TUdCURUrlb47NTM/yya8/X5B
         7t9ZfeEWE23rwYfRhYtZSsKfx8mnhO7JD1m3Y94k2qW1X0BaPZXNyNl+qUAYxzJ1GUIj
         /uP6t4gEF8StETcq/5bzKm9Qu/RDuWTikCwzQi8/Hy/6qPNekX+/oNaqkCrAbf7bSFNp
         xkHN96CCSz6K8quqMJhLRJ/jCtmJYq2Ng4vJ7+Mi3rkK5gaOIjsFNTQoKvNyNgjuAc1A
         CxYtHZVIKEDWEh619rv6gHh1gWiea9SmGsG1KrdX+OUG8TxlW3JwN6ajANl/KKUuPyMV
         RyDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786641914; x=1787246714;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=F9XLCxOIm85fIIs/oaVmZtJIQ13dsGAPw34yNA1NUWg=;
        b=NPEqbBrk7Ubu7HY8kikcKx+gtPWmnp+fzvYZRgIabOjOnyBx0Ow+FGB1FejI4N/4cz
         nsam9STEehgB8xZl6IZzZl0/y1ZwXFB53RapXjHKKaz9gNdXj9ghUel0PZ+pU+ERy1uJ
         gSaxouumrdNae3S9AXSVxvTCwUAVkLglXGPDw9lXB3UgCzVfH4i8LwncQXyvIK8bsBu/
         zqKiTuFo5ojyilbJDAZu9A1RPCIuPQ49Qa+q9YEEDu3jJRdAeg9mZtI0VZUnhENJT1kH
         AYnMDfRrjg5p6Pn7W5YCJKfMWyuhWcnA1qRSJi6FGCX6R7eXL7XREkg7PSq5H2qsBxBT
         7MiA==
X-Forwarded-Encrypted: i=1; AHgh+Rq65R0FxLeYFH6ioV5zLdP7W/2T+u2WVDDIoAyCbYQPbkfAZoSUR49aopnyxXo3Lo0vD5erj85GXt1onLIZAA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyWVsS8sMRfQUDTKas+FdaCY+s7N8p9y+b2Ka7uvwt5sYTA7sPL
	to2ucLP5pw+0myucW/jbWYG5SH6eqd/PcFo4GrGkITCyZlMQnB38HgPevf86z6rENHN89RBAKem
	27urg0OlpkuZT6GN4OBV8nqnjUvoh1HqIGGgcN+wY4T7m45/aU6H0Bv6huG4Bq+u6ezKDCA==
X-Gm-Gg: AR+sD12PgzVTG9mh1YDqzr9vKrhh3ddBBVF0we9UTg4koRpkU4f4gsQIY7UfIvGZbK7
	65EAX6kxXKSIJOqqT9pPyfgAi6+xRRp6goQR6fVEhGoaSugIhK/rwfXYrbD/6l37belkpDthXO/
	e46m2iWSPRwN7vMox1/8AhP9CYhYHbj6OHRVEUFY7FNBOi6eM/RL9dUjJoAZ44qL7qgF+jfDTQK
	ltsJNSfyZ8FrGhvvnURtCgeRBm1X8VXMP+1TQ6VxCTMvwfiNl9e6yus2ukHBD4NgQNLeCPDW9kD
	Nm+A0g7pw9GBeef4ECSlRqV86hsh9F67W9EacbT6tKwau0s1tSB86A0bWaj0py57gPGcjQK7epY
	yVaDKKNZChyA5WiW2le/xf1xFUw5TxDPFXuh4U8L+KIcbrclFwxdIkMZahprq
X-Received: by 2002:a17:90b:580e:b0:37c:18e0:90dc with SMTP id 98e67ed59e1d1-3931e2537dbmr9784668a91.16.1786641913632;
        Thu, 13 Aug 2026 10:25:13 -0700 (PDT)
X-Received: by 2002:a17:90b:580e:b0:37c:18e0:90dc with SMTP id 98e67ed59e1d1-3931e2537dbmr9784609a91.16.1786641913128;
        Thu, 13 Aug 2026 10:25:13 -0700 (PDT)
Received: from [10.227.105.111] (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31ebc75d8d6sm10610340eec.4.2026.08.13.10.25.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Aug 2026 10:25:12 -0700 (PDT)
Message-ID: <0bac4c07-6c78-478c-b3ec-1d897cdd8acf@oss.qualcomm.com>
Date: Thu, 13 Aug 2026 10:25:11 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 4/4] wifi: ath12k: implement custom wake_tx_queue with
 flow control
To: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Cc: ath11k@lists.infradead.org, ath12k@lists.infradead.org,
        jjohnson@kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, pengdonglin <dolinux.peng@gmail.com>,
        =?UTF-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
References: <0b72231d-59f8-49bf-82a0-76d2c7862729@oss.qualcomm.com>
 <20260811111405.397112-1-jtornosm@redhat.com>
Content-Language: en-US
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
In-Reply-To: <20260811111405.397112-1-jtornosm@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=NsfhtcdJ c=1 sm=1 tr=0 ts=6a7dfdfa cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=aIEVAj3FgTlWRZ7fGdMA:9 a=QEXdDO2ut3YA:10
 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODEzMDEyNSBTYWx0ZWRfX66/gIP5oln24
 ISl7+98JrfYG1kebIKPrVgoLKvzOfnddU23UeRTGn/8i3sGTFYCesMo8F4LrWbJWo9DjgE7RYjw
 b4CHElBuFpBBiiMxHNq/m67jZzZYsx+N3rRGesRR2OOENGEyLo/oqhHcyJ10Hf+CwbZY5SQmMYV
 dIYya0dKZPfj2PoKAfSjhSaXowggW9O98lp1KRpJoHH0zdUD7oG28c2fl+MgfmW0saisSkp0OnX
 cJFT8qH9T2LoBWDWFFVJB8joT9V+DHZpjW0EcwinJVHSBsstqKG5VytG2vfMMHxoYV7osWwIJUe
 YWqcGvj/M/oCYWWeCrYJw2gPvHenamwY3ONFuzVR9Ys0rIYFreUA2RC/tyxl1LLOiptfv237/oS
 kD+rNZzUQMKObidg0datPuhzBbEVlBNUpmSFj46SRUOrA0GCc0tqHrTgcDq0Uqf2/rXKPlx6gjB
 XjW2g/Fub0mOPDl62yQ==
X-Proofpoint-ORIG-GUID: WE-OWtaHF2JSbSRLGAFWZVvxSIf5TP9m
X-Proofpoint-GUID: WE-OWtaHF2JSbSRLGAFWZVvxSIf5TP9m
X-Proofpoint-Spam-Info: AW1haW4tMjYwODEzMDEyNSBTYWx0ZWRfX1CnuoCNcWASW
 mnZc3G20l9aCbnHDCaWJPPFNSmN39NJLDplMCb/2t1Uir4oIyjhPA2JgueyyNh0zLKXnJFDhfvp
 yuJAu/dgLn5uXGxwx+lC4Ywgm5VyJ8g=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-13_05,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 spamscore=0 bulkscore=0 adultscore=0
 clxscore=1015 priorityscore=1501 malwarescore=0 suspectscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608130125

On 8/11/2026 4:14 AM, Jose Ignacio Tornos Martinez wrote:
> Keeping rcu_read_lock() for the entire function is intentional. 
> ath12k_wifi7_mac_op_tx() calls rcu_dereference() internally (on ahvif->link[]
> and ahsta->link[]), and with CONFIG_DEBUG_LOCK_ALLOC, rcu_dereference() checks
> lock_is_held(&rcu_lock_map) via rcu_read_lock_held(). 
> Only an explicit rcu_read_lock() sets rcu_lock_map and spin_lock_bh() does not,
> so releasing early would trigger lockdep warnings.

hmm, so some of the following commits are broken?
https://lore.kernel.org/all/20250916044735.2316171-1-dolinux.peng@gmail.com/

In particular the one that I merged into ath9k:
https://lore.kernel.org/all/20250916044735.2316171-15-dolinux.peng@gmail.com/

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c
b/drivers/net/wireless/ath/ath9k/xmit.c
index 0ac9212e42f7..4a0f465aa2fe 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1993,7 +1993,6 @@ void ath_txq_schedule(struct ath_softc *sc, struct
ath_txq *txq)

 	ieee80211_txq_schedule_start(hw, txq->mac80211_qnum);
 	spin_lock_bh(&sc->chan_lock);
-	rcu_read_lock();

 	if (sc->cur_chan->stopped)
 		goto out;
@@ -2011,7 +2010,6 @@ void ath_txq_schedule(struct ath_softc *sc, struct
ath_txq *txq)
 	}

 out:
-	rcu_read_unlock();
 	spin_unlock_bh(&sc->chan_lock);
 	ieee80211_txq_schedule_end(hw, txq->mac80211_qnum);
 }

I fed that into my review agent and it confirms your observation:
  The change works correctly on production kernels without
  CONFIG_DEBUG_LOCK_ALLOC. It will produce a false lockdep splat on debug
  kernels with CONFIG_PROVE_RCU because rcu_dereference() checks
  rcu_read_lock_held() which requires an explicit rcu_read_lock(), not just a
  spinlock.

I have a fixup for ath9k which does:
      171 -  ratetbl = rcu_dereference(sta->rates);
      171 +  ratetbl = rcu_dereference_bh(sta->rates);

Should ath12k also use rcu_dereference_bh()?

/jeff


Received: from mta0.migadu.com (out-121.mta0.migadu.com [91.218.175.121])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC4113D6465
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 09:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.121
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787131102; cv=none; b=V5cg0Sp5aV/LmLLTNbhYKJXs4zgx5ylWylHFNccpYtI6+Tjk3Jb2tdRaVaOXM/q83Vd2QxwsAlIIlQ9vpg9QaSLRVdQD+U0oQ33ZRAkdUniF9rx40PlOZIpQZpvJbks1z96F/BGE4yzXwTYgE9KmWplC8KYpIFPn4rEfGhMDF2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787131102; c=relaxed/simple;
	bh=TX6877FJkQoV7h2ddq34564u66tziExxw7N+KyZCcsU=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=pswzYegRVlfExICNIIAMyV0E6rOSAVKSTSreLtTAjGOKnjX9Nslf8oAAFmbaohtw61cugqw/pQWTMPOTE8HmF8IwcJp+3sSHUVrBaGonsIoPxAWyE5rnfPwFRxbTbpo+krvaMrquLhOnVld3VxVhGVtI3/cAcd/hhaRkqBUEDAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=b0Yh67GM; arc=none smtp.client-ip=91.218.175.121
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="b0Yh67GM"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=TX6877FJkQoV7h2ddq34564u66tziExxw7N+KyZCcsU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787131082; v=1; x=1787735882;
 b=b0Yh67GMFhayDh14i4eBRNgtcIHSBuauNuV1u4cOyHnDNqD7Jgp7OTrdNC8icHzSWzJgdlcE
 h0MI8MZGkgPqyxgd6Hjbn/Ccc5F2lXEMj4/uAQ9rkxly1McDpIl8CBFaxLbwcB+8wYMF/6Vtr2B
 T5JYG+oVSbzL9ymYV1UNrjiY=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: from ehlo.thunderbird.net (2a06:63c5:9b00:3900:e1b3:d7a6:6110:4f65)
	by smtp.migadu.com with ESMTPS id 03b6973c4a51d997;
	Wed, 19 Aug 2026 09:18:02 +0000
X-Migadu-Flow: FLOW_OUT
Date: Wed, 19 Aug 2026 11:17:57 +0200
From: Luka Gejak <luka.gejak@linux.dev>
To: Ping-Ke Shih <pkshih@realtek.com>,
 "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Michael Straube <straube.linux@gmail.com>,
 Bitterblue Smith <rtl8821cerfe2@gmail.com>,
 Peter Robinson <pbrobinson@gmail.com>,
 Hans de Goede <johannes.goede@oss.qualcomm.com>, luka.gejak@linux.dev
Subject: =?US-ASCII?Q?RE=3A_=5BPATCH_v5_6/6=5D_wifi=3A_rtw88=3A_sdio=3A_add_T?=
 =?US-ASCII?Q?X_back-pressure_and_retry_on_page_starvation?=
User-Agent: Thunderbird for Android
In-Reply-To: <459e54292cf245e2ae6fd1a46afb6ec7@realtek.com>
References: <20260814105327.6687-1-luka.gejak@linux.dev> <20260814105327.6687-7-luka.gejak@linux.dev> <257b9af907e84e439ae6a9fd55bf3f09@realtek.com> <20260819071932.19596-1-luka.gejak@linux.dev> <459e54292cf245e2ae6fd1a46afb6ec7@realtek.com>
Message-ID: <EAB14669-5E6A-4BC6-80C3-C2309E6409FF@linux.dev>
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

> I didn't get this point=2E I'll review carefully on this part in v6=2E

Easier to see side by side, so here it is in full=2E

Upstream ignores the return value of rtw_sdio_process_tx_queue():

        rtw_sdio_process_tx_queue(rtwdev, queue);

        if (skb_queue_empty(&rtwsdio->tx_queue[queue]))
                break;

and that function puts the frame back when the write fails:

        ret =3D rtw_sdio_write_port(rtwdev, skb, queue);
        if (ret) {
                skb_queue_head(&rtwsdio->tx_queue[queue], skb);
                return;
        }

So after a failure the queue is not empty, the loop does not break, and
the transfer is retried, up to the limit of 1000=2E rtw_sdio_write_port()
returning -EBUSY from rtw_sdio_check_free_txpg() is the ordinary case
here, and upstream just spins until pages free up=2E

v4 and v5 put this in the same loop:

        ret =3D rtw_sdio_process_tx_queue(rtwdev, queue);
        if (ret > 0)
                break;

        if (ret < 0) {
                if (rtl8723bs && (ret =3D=3D -EBUSY || ret =3D=3D -ENOMEM)=
) {
                        rtw_sdio_reschedule_tx_work(=2E=2E=2E);
                        return;
                }
                break;
        }

The inner condition is chip gated=2E The break is not=2E On every other SD=
IO
part rtl8723bs is false, so any error, including that ordinary -EBUSY,
now leaves the loop and abandons the queue for the rest of the pass
instead of retrying it=2E That is the change I did not intend, and it was
not in v3=2E

v6 has no break there at all:

        ret =3D rtw_sdio_process_tx_queue(rtwdev, queue);
        if (ret > 0)
                break;

        if (rtw_sdio_8723bs_reschedule_tx(rtwdev, work_data, queue, ret))
                return;

        if (skb_queue_empty(&rtwsdio->tx_queue[queue]))
                break;

rtw_sdio_8723bs_reschedule_tx() returns false on its first line for
anything that is not an RTL8723BS, so the other parts get process,
requeue on failure, queue not empty, retry, which is upstream's flow=2E

> If you have another SDIO chip, such as RTL8723CS, please verify your
> patches on another real hardware, because it is not possible to catch
> all flaws by reviewer (like me)=2E Using real hardware with a simple
> throughput test is more important=2E

Agreed, and you are right to ask=2E I do not have another SDIO part=2E The
only SDIO hardware I have is the RTL8723BS, so I cannot give you a
measured result on another chip, and I would rather say so than imply
coverage I do not have=2E This is exactly the bug you would expect that
gap to produce=2E

So that a reviewer knows where to look, after v6 the other SDIO parts
see three changes, all structural:

  - rtw_sdio_tx_kick_off() uses mod_delayed_work(=2E=2E=2E, 0) instead of
    queue_work()=2E Only the RTL8723BS ever arms a delay, so for the
    others the work is always queued immediately, as before=2E
  - INIT_WORK() becomes INIT_DELAYED_WORK() on the same handler=2E
  - rtw_sdio_deinit_tx() gains cancel_delayed_work_sync() before
    destroy_workqueue(), needed once the item is a delayed work, and a
    no-op where no timer is ever armed=2E

Everything else is behind rtw_is_8723bs()=2E

If anyone on the list has an RTL8723CS, RTL8822BS or RTL8821CS to hand,
the full tree is at:

  https://github=2Ecom/MocLG/rtw/tree/8723bs-v6

and a plain iperf3 run either way is all it needs=2E I will take any
result on another part over my own reading of the diff=2E

Best regards,
Luka Gejak

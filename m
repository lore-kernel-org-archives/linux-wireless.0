Return-Path: <SRS0=FsXk=RO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56B88C43381
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 10:07:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE29D20657
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 10:07:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="Drulizvz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726969AbfCKKHR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Mar 2019 06:07:17 -0400
Received: from nbd.name ([46.4.11.11]:46818 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726623AbfCKKHR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Mar 2019 06:07:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ntfIyEByyU4pCLIjQKXHwVYQhJjYKFNmyfVi2voHcd0=; b=Drulizvzc72a3exTvCPTrstuZS
        HtzEz0p4NM2J1/tITvUQRnS/mj9e7HaKJ1tL3HS4Yd6JszIgt6q2ZN/t1S4iMkFfmm/Xa54tCzqcg
        0w88+RQlsZ0dS9MqfBWwcQfIM/p4TLRG+zhC9ailmwxEW+Jj0JY6H/8f7xDdAXcpT/cw=;
Subject: Re: [PATCH] mt76: fix schedule while atomic in mt76x02_reset_state
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     linux-wireless@vger.kernel.org, sgruszka@redhat.com,
        lorenzo.bianconi@redhat.com
References: <cover.1552251427.git.lorenzo@kernel.org>
 <510d7b670f673a4662ed672b0ce3d9f75512b100.1552251427.git.lorenzo@kernel.org>
From:   Felix Fietkau <nbd@nbd.name>
Openpgp: preference=signencrypt
Autocrypt: addr=nbd@nbd.name; prefer-encrypt=mutual; keydata=
 mQGiBEah5CcRBADIY7pu4LIv3jBlyQ/2u87iIZGe6f0f8pyB4UjzfJNXhJb8JylYYRzIOSxh
 ExKsdLCnJqsG1PY1mqTtoG8sONpwsHr2oJ4itjcGHfn5NJSUGTbtbbxLro13tHkGFCoCr4Z5
 Pv+XRgiANSpYlIigiMbOkide6wbggQK32tC20QxUIwCg4k6dtV/4kwEeiOUfErq00TVqIiEE
 AKcUi4taOuh/PQWx/Ujjl/P1LfJXqLKRPa8PwD4j2yjoc9l+7LptSxJThL9KSu6gtXQjcoR2
 vCK0OeYJhgO4kYMI78h1TSaxmtImEAnjFPYJYVsxrhay92jisYc7z5R/76AaELfF6RCjjGeP
 wdalulG+erWju710Bif7E1yjYVWeA/9Wd1lsOmx6uwwYgNqoFtcAunDaMKi9xVQW18FsUusM
 TdRvTZLBpoUAy+MajAL+R73TwLq3LnKpIcCwftyQXK5pEDKq57OhxJVv1Q8XkA9Dn1SBOjNB
 l25vJDFAT9ntp9THeDD2fv15yk4EKpWhu4H00/YX8KkhFsrtUs69+vZQwbQcRmVsaXggRmll
 dGthdSA8bmJkQG5iZC5uYW1lPohgBBMRAgAgBQJGoeQnAhsjBgsJCAcDAgQVAggDBBYCAwEC
 HgECF4AACgkQ130UHQKnbvXsvgCgjsAIIOsY7xZ8VcSm7NABpi91yTMAniMMmH7FRenEAYMa
 VrwYTIThkTlQuQINBEah5FQQCACMIep/hTzgPZ9HbCTKm9xN4bZX0JjrqjFem1Nxf3MBM5vN
 CYGBn8F4sGIzPmLhl4xFeq3k5irVg/YvxSDbQN6NJv8o+tP6zsMeWX2JjtV0P4aDIN1pK2/w
 VxcicArw0VYdv2ZCarccFBgH2a6GjswqlCqVM3gNIMI8ikzenKcso8YErGGiKYeMEZLwHaxE
 Y7mTPuOTrWL8uWWRL5mVjhZEVvDez6em/OYvzBwbkhImrryF29e3Po2cfY2n7EKjjr3/141K
 DHBBdgXlPNfDwROnA5ugjjEBjwkwBQqPpDA7AYPvpHh5vLbZnVGu5CwG7NAsrb2isRmjYoqk
 wu++3117AAMFB/9S0Sj7qFFQcD4laADVsabTpNNpaV4wAgVTRHKV/kC9luItzwDnUcsZUPdQ
 f3MueRJ3jIHU0UmRBG3uQftqbZJj3ikhnfvyLmkCNe+/hXhPu9sGvXyi2D4vszICvc1KL4RD
 aLSrOsROx22eZ26KqcW4ny7+va2FnvjsZgI8h4sDmaLzKczVRIiLITiMpLFEU/VoSv0m1F4B
 FtRgoiyjFzigWG0MsTdAN6FJzGh4mWWGIlE7o5JraNhnTd+yTUIPtw3ym6l8P+gbvfoZida0
 TspgwBWLnXQvP5EDvlZnNaKa/3oBes6z0QdaSOwZCRA3QSLHBwtgUsrT6RxRSweLrcabiEkE
 GBECAAkFAkah5FQCGwwACgkQ130UHQKnbvW2GgCfTKx80VvCR/PvsUlrvdOLsIgeRGAAn1ee
 RjMaxwtSdaCKMw3j33ZbsWS4
Message-ID: <09c3c2ec-071f-4fd9-927d-2981b65fe29f@nbd.name>
Date:   Mon, 11 Mar 2019 11:07:14 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <510d7b670f673a4662ed672b0ce3d9f75512b100.1552251427.git.lorenzo@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2019-03-10 23:47, Lorenzo Bianconi wrote:
> Fix following schedule while atomic mt76x02_reset_state
> since synchronize_rcu is run inside a RCU section
> 
> [44036.944222] mt76x2e 0000:06:00.0: MCU message 31 (seq 3) timed out
> [44036.944281] BUG: sleeping function called from invalid context at kernel/rcu/tree_exp.h:818
> [44036.944284] in_atomic(): 1, irqs_disabled(): 0, pid: 28066, name: kworker/u4:1
> [44036.944287] INFO: lockdep is turned off.
> [44036.944292] CPU: 1 PID: 28066 Comm: kworker/u4:1 Tainted: G        W         5.0.0-rc7-wdn-t1+ #7
> [44036.944294] Hardware name: Dell Inc. Studio XPS 1340/0K183D, BIOS A11 09/08/2009
> [44036.944305] Workqueue: phy1 mt76x02_wdt_work [mt76x02_lib]
> [44036.944308] Call Trace:
> [44036.944317]  dump_stack+0x67/0x90
> [44036.944322]  ___might_sleep.cold.88+0x9f/0xaf
> [44036.944327]  rcu_blocking_is_gp+0x13/0x50
> [44036.944330]  synchronize_rcu+0x17/0x80
> [44036.944337]  mt76_sta_state+0x138/0x1d0 [mt76]
> [44036.944349]  mt76x02_wdt_work+0x1c9/0x610 [mt76x02_lib]
> [44036.944355]  process_one_work+0x2a5/0x620
> [44036.944361]  worker_thread+0x35/0x3e0
> [44036.944368]  kthread+0x11c/0x140
> [44036.944376]  ret_from_fork+0x3a/0x50
> [44036.944384] BUG: scheduling while atomic: kworker/u4:1/28066/0x00000002
> [44036.944387] INFO: lockdep is turned off.
> [44036.944389] Modules linked in: cmac ctr ccm af_packet snd_hda_codec_hdmi
> 
> Introduce __mt76_sta_remove in order to run sta_remove without holding dev->mutex.
> Move __mt76_sta_remove outside RCU section in mt76x02_reset_state
> 
> Fixes: e4ebb8b403d1 ("mt76: mt76x2: implement full device restart on watchdog reset")
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
> index 6a34a6afcfe4..898afcbcdf52 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
> @@ -419,6 +419,7 @@ static void mt76x02_key_sync(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
>  	mt76x02_mac_wcid_sync_pn(dev, wcid->idx, key);
>  }
>  
> +/* need to run with mt76.mutex held */
>  static void mt76x02_reset_state(struct mt76x02_dev *dev)
You can replace that comment with a call to lockdep_assert_held in the
function.

> @@ -426,11 +427,11 @@ static void mt76x02_reset_state(struct mt76x02_dev *dev)
>  	clear_bit(MT76_STATE_RUNNING, &dev->mt76.state);
>  
>  	rcu_read_lock();
> -
>  	ieee80211_iter_keys_rcu(dev->mt76.hw, NULL, mt76x02_key_sync, NULL);
> +	rcu_read_unlock();
>  
>  	for (i = 0; i < ARRAY_SIZE(dev->mt76.wcid); i++) {
> -		struct mt76_wcid *wcid = rcu_dereference(dev->mt76.wcid[i]);
> +		struct mt76_wcid *wcid = dev->mt76.wcid[i];
This should use rcu_dereference_protected() instead of accessing the
pointer directly.

Thanks,

- Felix

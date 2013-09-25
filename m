Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f53.google.com ([209.85.214.53]:35958 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755142Ab3IYKq7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Sep 2013 06:46:59 -0400
Received: by mail-bk0-f53.google.com with SMTP id d7so2159261bkh.40
        for <linux-wireless@vger.kernel.org>; Wed, 25 Sep 2013 03:46:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1380101891-18312-9-git-send-email-bartosz.markowski@tieto.com>
References: <1380101891-18312-1-git-send-email-bartosz.markowski@tieto.com>
	<1380101891-18312-9-git-send-email-bartosz.markowski@tieto.com>
Date: Wed, 25 Sep 2013 12:46:58 +0200
Message-ID: <CA+BoTQ=p5_V7CDJsv3xZPAPM0y-rc_Ck7LAjX8=Wf1QXujC2JQ@mail.gmail.com> (sfid-20130925_124703_407064_B003C52E)
Subject: Re: [PATCH 08/13] ath10k: bring back the WMI path for mgmt frames
From: Michal Kazior <michal.kazior@tieto.com>
To: Bartosz Markowski <bartosz.markowski@tieto.com>
Cc: ath10k@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 25 September 2013 11:38, Bartosz Markowski
<bartosz.markowski@tieto.com> wrote:
> @@ -1497,16 +1497,23 @@ static void ath10k_tx_htt(struct ath10k *ar, struct sk_buff *skb)
>                 goto exit;
>         }
>
> -       if (ieee80211_is_mgmt(hdr->frame_control))
> -               ret = ath10k_htt_mgmt_tx(&ar->htt, skb);
> -       else if (ieee80211_is_nullfunc(hdr->frame_control))
> +       if (ieee80211_is_mgmt(hdr->frame_control)) {
> +               if (test_bit(ATH10K_FW_FEATURE_HAS_WMI_MGMT_TX,
> +                            ar->fw_features))
> +                       ret = ath10k_wmi_mgmt_tx(ar, skb);

Due to recent changes (WMI commands can block/sleep) this cannot be
so. ath10k_tx_htt() is called from an atomic context.

I'm seeing 2 aproaches here:
 a) management frame queue,
 b) use ieee80211_{stop,wake}_queues()

I'm worried (b) could degrade throughput. WMI endpoint has only 2 HTC
credits meaning management frame bursts will lock out data frame tx.


Michał.

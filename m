Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:61898 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753921AbaJ1LeO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2014 07:34:14 -0400
Received: by mail-wg0-f50.google.com with SMTP id z12so567557wgg.21
        for <linux-wireless@vger.kernel.org>; Tue, 28 Oct 2014 04:34:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1413809925-4352-8-git-send-email-michal.kazior@tieto.com>
References: <1413809925-4352-1-git-send-email-michal.kazior@tieto.com>
	<1413809925-4352-8-git-send-email-michal.kazior@tieto.com>
Date: Tue, 28 Oct 2014 12:34:12 +0100
Message-ID: <CA+BoTQ=J2cQqYzOa37+BOsmqgv5j7qdTc+XmaaYV6TvS98R0SA@mail.gmail.com> (sfid-20141028_123423_729006_5BFE9B0F)
Subject: Re: [PATCH 7/7] ath10k: implement wmi-tlv backend
From: Michal Kazior <michal.kazior@tieto.com>
To: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 20 October 2014 14:58, Michal Kazior <michal.kazior@tieto.com> wrote:
> Latest firmware revision introduced a new WMI ABI
> called wmi-tlv. It is not a tlv strictly speaking
> but something that resembles it because it is
> ordered and may have duplicate id entries.
>
> This will be used by new hardware eventually.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
> ---
[...]
> +static struct sk_buff *
> +ath10k_wmi_tlv_op_gen_pdev_set_wmm(struct ath10k *ar,
> +                                  const struct wmi_pdev_set_wmm_params_arg *arg)
> +{
[...]
> +       ptr = ath10k_wmi_tlv_put_wmm(ptr, &arg->ac_be);
> +       ptr = ath10k_wmi_tlv_put_wmm(ptr, &arg->ac_be);
> +       ptr = ath10k_wmi_tlv_put_wmm(ptr, &arg->ac_be);
> +       ptr = ath10k_wmi_tlv_put_wmm(ptr, &arg->ac_be);

Oops, this should use called for be, bk, vi, vo.


Michał

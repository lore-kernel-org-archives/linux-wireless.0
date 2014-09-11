Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:56478 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753968AbaIKJrf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2014 05:47:35 -0400
Received: by mail-we0-f176.google.com with SMTP id q58so6460859wes.7
        for <linux-wireless@vger.kernel.org>; Thu, 11 Sep 2014 02:47:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140910152329.12610.41409.stgit@potku.adurom.net>
References: <20140910152136.12610.18499.stgit@potku.adurom.net>
	<20140910152329.12610.41409.stgit@potku.adurom.net>
Date: Thu, 11 Sep 2014 11:47:34 +0200
Message-ID: <CA+BoTQkBiKPzHBfTA2xpmgbUbutSj5Z6w6gP7EO6aotacM5_cA@mail.gmail.com> (sfid-20140911_114739_079155_DF6A3890)
Subject: Re: [PATCH v4 2/2] ath10k: add testmode
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10 September 2014 17:23, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
[...]

Just a small nitpick:

> +static int ath10k_tm_cmd_utf_stop(struct ath10k *ar, struct nlattr *tb[])
> +{
> +       int ret;
> +
> +       ath10k_dbg(ar, ATH10K_DBG_TESTMODE, "testmode cmd utf stop\n");
> +
> +       mutex_lock(&ar->conf_mutex);
> +
> +       if (ar->state != ATH10K_STATE_UTF) {
> +               ret = -ENETDOWN;
> +               goto out;
> +       }
> +
> +       __ath10k_tm_cmd_utf_stop(ar);
> +
> +       ar->state = ATH10K_STATE_OFF; // <-- this

I would move it to __ath10k_tm_cmd_utf_stop() itself so that the state
is reset in ath10k_testmode_destroy() as well.


Michał

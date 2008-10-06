Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.232]:50940 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329AbYJFOlX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2008 10:41:23 -0400
Received: by wx-out-0506.google.com with SMTP id h27so593389wxd.4
        for <linux-wireless@vger.kernel.org>; Mon, 06 Oct 2008 07:41:22 -0700 (PDT)
Message-ID: <1ba2fa240810060741o35c8071ere77460305b88545c@mail.gmail.com> (sfid-20081006_164126_750685_1E2C2883)
Date: Mon, 6 Oct 2008 16:41:20 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Rami Rosen" <ramirose@gmail.com>
Subject: Re: [PATCH 1/2] iwlwifi: fix compliation warning in iwl-agn-rs.c when CONFIG_IWLWIFI_DEBUG is not set.
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	yi.zhu@intel.com
In-Reply-To: <eb3ff54b0810060658p2241a6d0k9c6f504d976e0f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <eb3ff54b0810060658p2241a6d0k9c6f504d976e0f@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 6, 2008 at 3:58 PM, Rami Rosen <ramirose@gmail.com> wrote:
> When CONFIG_IWLWIFI_DEBUG is not set and CONFIG_IWLWIFI is set,
> we get this compilation warning:
> /wireless-next-2.6/drivers/net/wireless/iwlwifi/iwl-agn-rs.c: In
> function 'rs_free_sta':
> /wireless-next-2.6/drivers/net/wireless/iwlwifi/iwl-agn-rs.c:2425:
> warning: unused variable 'priv'
>
> This patch (against wireless-next-2.6 tree) fixes it.
>

I prefer marking it.
struct iwl_priv *priv = priv_r __maybe_unused;

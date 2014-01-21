Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:43428 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452AbaAUTDF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jan 2014 14:03:05 -0500
Received: by mail-wi0-f182.google.com with SMTP id ex4so4753150wid.3
        for <linux-wireless@vger.kernel.org>; Tue, 21 Jan 2014 11:03:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1390166509-3992-1-git-send-email-andrea.merello@gmail.com>
References: <1390166509-3992-1-git-send-email-andrea.merello@gmail.com>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Wed, 22 Jan 2014 00:32:42 +0530
Message-ID: <CABPxzYKykToRsDanUpUdcE7xvsiPZ2E-fMG7B=Xn9JkuXGAHGQ@mail.gmail.com> (sfid-20140121_200309_428191_A0CF8720)
Subject: Re: [PATCH] mac80211: add check on hw->max_signal value on ieee80211_register_hw
To: andrea merello <andrea.merello@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 20, 2014 at 2:51 AM, andrea merello
<andrea.merello@gmail.com> wrote:
>
> +       if (hw->flags &
> IEEE80211_HW_SIGNAL_UNSPEC && hw->max_signal <= 0)
> +               return -EINVAL;
> +

Should we add a check for > 100 as well, similar to cfg?

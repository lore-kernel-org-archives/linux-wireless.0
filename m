Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.182]:7423 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754091AbYBOWID (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Feb 2008 17:08:03 -0500
Received: by py-out-1112.google.com with SMTP id u52so1040892pyb.10
        for <linux-wireless@vger.kernel.org>; Fri, 15 Feb 2008 14:08:01 -0800 (PST)
Message-ID: <43e72e890802151408g35fa2e49r5eb8557e4a5bbce4@mail.gmail.com> (sfid-20080215_220808_247717_03837F94)
Date: Fri, 15 Feb 2008 17:08:00 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: [PATCH 2/3] WDEV, ath5k, don't return int from bool function
Cc: linville@tuxdriver.com, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	"Nick Kossifidis" <mickflemm@gmail.com>
In-Reply-To: <1203109133-32217-2-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1203109133-32217-1-git-send-email-jirislaby@gmail.com>
	 <1203109133-32217-2-git-send-email-jirislaby@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 15, 2008 at 3:58 PM, Jiri Slaby <jirislaby@gmail.com> wrote:

>  -static bool
>  +static int
>   ath5k_hw_setup_xr_tx_desc(struct ath5k_hw *ah, struct ath5k_desc *desc,
>         unsigned int tx_rate1, u_int tx_tries1, u_int tx_rate2, u_int tx_tries2,
>         unsigned int tx_rate3, u_int tx_tries3)
>  @@ -3773,10 +3773,10 @@ ath5k_hw_setup_xr_tx_desc(struct ath5k_hw *ah, struct ath5k_desc *desc,
>
>   #undef _XTX_TRIES
>
>  -               return true;
>  +               return 1;
>         }
>
>  -       return false;
>  +       return 0;
>   }

Shouldn't we then treat 0 as OK?

  Luis

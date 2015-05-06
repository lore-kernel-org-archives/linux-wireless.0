Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49860 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617AbbEFE7N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 May 2015 00:59:13 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Okash Khawaja <okash.khawaja@gmail.com>
Cc: joe@perches.com, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] adm8211: fix the possible pci cache line sizes inside switch-case
References: <20150505224020.GA3805@bytefire-computer>
Date: Wed, 06 May 2015 07:59:04 +0300
In-Reply-To: <20150505224020.GA3805@bytefire-computer> (Okash Khawaja's
	message of "Tue, 5 May 2015 23:40:20 +0100")
Message-ID: <87wq0ms3mv.fsf@kamboji.qca.qualcomm.com> (sfid-20150506_065920_254444_1C832708)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Okash Khawaja <okash.khawaja@gmail.com> writes:

> The PCI cache line size value was being compared against decimal values prefixed with 0x.
>
> Fixed the literals to use the correct hex values.
>
>
> Signed-off-by: Okash Khawaja <okash.khawaja@gmail.com>

[...]

> @@ -1101,10 +1101,10 @@ static void adm8211_hw_init(struct ieee80211_hw *dev)
>  		case  0x8:
>  			reg |= (0x1 << 14);
>  			break;
> -		case 0x16:
> +		case 0x10:
>  			reg |= (0x2 << 14);
>  			break;
> -		case 0x32:
> +		case 0x20:
>  			reg |= (0x3 << 14);
>  			break;
>  		default:

Did you test this? How certain can we be that this doesn't break
anything?

-- 
Kalle Valo

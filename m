Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:36455 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755045AbXLHJvj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Dec 2007 04:51:39 -0500
Date: Sat, 8 Dec 2007 10:45:49 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Stefano Brivio <stefano.brivio@polimi.it>
Cc: "Nick Kossifidis" <mickflemm@gmail.com>,
	"Mattias Nissler" <mattias.nissler@gmx.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [RFC][PATCH] mac80211: Use PID controller for TX rate control
Message-ID: <20071208104549.608bf66d@morte> (sfid-20071208_095143_397176_C60D5D29)
In-Reply-To: <20071204024146.15689ee3@morte>
References: <1196622331.7472.4.camel@localhost>
	<20071203041608.3af3b462@morte>
	<1196679780.7470.9.camel@localhost>
	<20071203125402.76562f26@morte>
	<1196683144.7470.14.camel@localhost>
	<20071203130602.49ab7234@morte>
	<40f31dec0712031442q51a658abwfde965dae3fb6b72@mail.gmail.com>
	<20071204024146.15689ee3@morte>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 4 Dec 2007 02:41:46 +0100
Stefano Brivio <stefano.brivio@polimi.it> wrote:

> -		err_avg = srctrl->err_avg_sc >> RATE_CONTROL_SMOOTHING_SHIFT;
> +		err_avg = srctrl->err_avg_sc >> modparam_rc_sh_s;
							     ^

>  		srctrl->err_avg_sc = srctrl->err_avg_sc - err_avg + err_prop;
> -		err_int = srctrl->err_avg_sc >> RATE_CONTROL_SMOOTHING_SHIFT;
> +		err_int = srctrl->err_avg_sc >> modparam_rc_sh_s;
							     ^

Sorry, I forgot to resend. Will send another patch soon so I won't bother.


-- 
Ciao
Stefano

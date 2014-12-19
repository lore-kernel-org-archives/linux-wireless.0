Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:15884 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751364AbaLSLhH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Dec 2014 06:37:07 -0500
Message-ID: <54940B8C.5070801@neratec.com> (sfid-20141219_123711_699555_9C6AC739)
Date: Fri, 19 Dec 2014 12:27:08 +0100
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
MIME-Version: 1.0
To: Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: DFS CAC time
References: <CAGXE3d8Uv01qjfvRQkMr1w_5wB6XKpC7d2VOR3UG0DMPHk6r9A@mail.gmail.com>
In-Reply-To: <CAGXE3d8Uv01qjfvRQkMr1w_5wB6XKpC7d2VOR3UG0DMPHk6r9A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/18/2014 05:21 PM, Helmut Schaa wrote:
> Hi,
> 
> [...]
> 
> So, every channel has a CAC time of 60 seconds.
> 
> Checking version 1.7.2 of the ETSI regulation indicates that we might
> need some modifications to cfg80211:
> 
> From [1] page 79:
> 
> "NOTE 1: For channels whose nominal bandwidth falls completely or
> partly within the
> band 5 600 MHz to 5 650 MHz, the Channel Availability Check Time shall be
> 10 minutes.
> NOTE 2: For channels whose nominal bandwidth falls completely or
> partly within the
> band 5 600 MHz to 5 650 MHz, the Off-Channel CAC Time shall be within the
> range 1 hour to 24 hours."
> 
> So, for these channels we should select a longer initial CAC time.
> 
> Is anyone aware of this issue?
> 
> Thanks,
> Helmut
> 
> 
> [1] http://www.etsi.org/deliver/etsi_en/301800_301899/301893/01.07.02_20/en_301893v010702a.pdf
> --

Hello Helmut,

just forget about those aka 'weather channels' that require a pracitcally
impossible to achieve radar detection probability rate (99.99% during CAC, see
table D.5).

They should simply be disabled, either at mac layer, or at least in ath/regd.c.


Cheers,
Zefir

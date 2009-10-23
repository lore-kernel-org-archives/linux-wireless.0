Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:56219 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017AbZJWOgT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2009 10:36:19 -0400
Received: by fg-out-1718.google.com with SMTP id d23so277446fga.1
        for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2009 07:36:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200910231608.18676.mb@bu3sch.de>
References: <200910231608.18676.mb@bu3sch.de>
Date: Fri, 23 Oct 2009 10:36:22 -0400
Message-ID: <b6c5339f0910230736h54d51fbfl4031da90c1238b86@mail.gmail.com>
Subject: Re: ath5k: no further txbuf available, dropping packet
From: Bob Copeland <me@bobcopeland.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 23, 2009 at 10:08 AM, Michael Buesch <mb@bu3sch.de> wrote:
> ath5k breaks in AP mode after some operation time and keeps throwing
> this message:
>
> [2096249.446071] ath5k phy0: no further txbuf available, dropping packet
>
> Driver is yesterday's compat-wireless on 2.6.31.1

Thanks, I think there's a buffer leak.  Also I believe the
queues are stopped in this case and never re-enabled.

-- 
Bob Copeland %% www.bobcopeland.com

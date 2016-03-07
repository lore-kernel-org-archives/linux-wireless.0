Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50206 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058AbcCGMXz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Mar 2016 07:23:55 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: mwifiex: Use to_delayed_work()
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20160217123336.GA30230@amitoj-Inspiron-3542>
To: Amitoj Kaur Chawla <amitoj1606@gmail.com>
Cc: akarwar@marvell.com, nishants@marvell.com,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, julia.lawall@lip6.fr
Message-Id: <20160307122354.663816074A@smtp.codeaurora.org> (sfid-20160307_132422_722716_4D2ACCEA)
Date: Mon,  7 Mar 2016 12:23:54 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Introduce the use of to_delayed_work() helper function instead of open
> coding it with container_of()
> 
> A simplified version of the Coccinelle semantic patch used to make
> this change is:
> 
> //<smpl>
> @@
> expression a;
> symbol work;
> @@
> - container_of(a, struct delayed_work, work)
> + to_delayed_work(a)
> //</smpl>
> 
> Signed-off-by: Amitoj Kaur Chawla <amitoj1606@gmail.com>
> Reviewed-by: Julian Calaby <julian.calaby@gmail.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo

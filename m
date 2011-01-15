Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:48045 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160Ab1AOC7s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Jan 2011 21:59:48 -0500
Received: by iwn9 with SMTP id 9so3118689iwn.19
        for <linux-wireless@vger.kernel.org>; Fri, 14 Jan 2011 18:59:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1295033760-31108-1-git-send-email-bzhao@marvell.com>
References: <1295033760-31108-1-git-send-email-bzhao@marvell.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Sat, 15 Jan 2011 13:59:27 +1100
Message-ID: <AANLkTi=BMTLa36FXW7nNHKu8=PgPCJC517vsmDDNZcYj@mail.gmail.com>
Subject: Re: [PATCH] mwifiex: remove duplicated NULL checks
To: Bing Zhao <bzhao@marvell.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Frank Huang <frankh@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jan 15, 2011 at 06:36, Bing Zhao <bzhao@marvell.com> wrote:
> From: Amitkumar Karwar <akarwar@marvell.com>
>
> Some functions have unnecessory NULL check for an input parameter
> because the caller to those functions is already checking the parameter
> for NULL before calling them.

It may be more readable and efficient to eliminate the NULL checks in
the callers - and adjust the code to inform the callers of the case
where the pointer passed is null and make the callers to properly
handle this case.

This should also make the driver more robust as failures can be passed
up the stack to places that can deal with them more effectively than
just printing a message.

Thanks,

-- 

Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/

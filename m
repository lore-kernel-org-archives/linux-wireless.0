Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46964 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754038AbdEKDqN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 May 2017 23:46:13 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Joe Perches <joe@perches.com>
Cc: Kees Cook <keescook@chromium.org>, netdev@vger.kernel.org,
        libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        Daniel Micay <danielmicay@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] libertas: Avoid reading past end of buffer
References: <20170510192451.GA115771@beast>
        <1494457506.2028.1.camel@perches.com>
Date: Thu, 11 May 2017 06:45:58 +0300
In-Reply-To: <1494457506.2028.1.camel@perches.com> (Joe Perches's message of
        "Wed, 10 May 2017 16:05:06 -0700")
Message-ID: <87fugcvyx5.fsf@kamboji.qca.qualcomm.com> (sfid-20170511_054813_545275_8E9DEB4D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Joe Perches <joe@perches.com> writes:

> unrelated trivia:
>
> lbs_deb_enter is used incorrectly here at
> function exit as both enter and leave calls.
>
> That type of copy/paste defect may be common.
>
> $ git grep -w lbs_deb_enter | wc -l
> 148
> $ git grep -w lbs_deb_leave | wc -l
> 71
>
> One would expect these numbers to be the same.
>
> Another option would be to delete all these
> calls as ftrace function tracing works well.

Yeah, deleting all the enter/exit calls would be better.

-- 
Kalle Valo

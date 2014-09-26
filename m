Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0039.hostedemail.com ([216.40.44.39]:35688 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754696AbaIZOO0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Sep 2014 10:14:26 -0400
Message-ID: <1411740861.19443.6.camel@joe-AO725> (sfid-20140926_161430_052108_E3225D90)
Subject: Re: [PATCH 0/4] ath10k: fix/cleanup fw stats
From: Joe Perches <joe@perches.com>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 26 Sep 2014 07:14:21 -0700
In-Reply-To: <CA+BoTQmJ-HprccxTO3UrX+NkhOMVt2i2X7p4k0b5bs6TVrKrpw@mail.gmail.com>
References: <1411641230-18785-1-git-send-email-michal.kazior@tieto.com>
	 <871tqy63p9.fsf@kamboji.qca.qualcomm.com>
	 <CA+BoTQmJ-HprccxTO3UrX+NkhOMVt2i2X7p4k0b5bs6TVrKrpw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-09-26 at 13:14 +0200, Michal Kazior wrote:
> On 26 September 2014 13:06, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> > drivers/net/wireless/ath/ath10k/wmi.c:1513: WARNING: else is not generally useful after a break or return
> I'm aware of this one but the code looks nicer with the `else` to me though.

Yay Michal.

Always use your taste over any mindless style tool.

Ignore any checkpatch complaint you want.

btw: checkpatch shouldn't warn about this as of:

commit adefeef310ee8bd3923d41b67bc53c398bc53621
Author: Joe Perches <joe@perches.com>
Date:   Fri Sep 26 10:19:29 2014 +1000

    checkpatch: add exception to return then else test
    
    Add an exception to the return before else warning
    when the line following it is also a return like:
    
        if (foo)
                return bar;
        else
                return baz;
    
    This form of a test then return is at least as readable as
    
        if (foo)
                return bar;
        return baz;
    
    so don't emit a warning on the first form.
    
    Signed-off-by: Joe Perches <joe@perches.com>
    Reported-by: Al Viro <viro@ZenIV.linux.org.uk>
    Cc: Elshad Mustafayev <elshadimo@gmail.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>



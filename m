Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:35608 "EHLO
        mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933217AbdCaRe4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Mar 2017 13:34:56 -0400
MIME-Version: 1.0
In-Reply-To: <1490981039.27353.12.camel@perches.com>
References: <e4556e95a5935f591fdff67c6fb2f7ef5c7fd04f.1490914618.git.joe@perches.com>
 <CALLGbR+szcYFdbdh_0qBS4B_X6YQvU6CDFpR-XZvc7p3zA+ZdQ@mail.gmail.com> <1490981039.27353.12.camel@perches.com>
From: Steve deRosier <derosier@gmail.com>
Date: Fri, 31 Mar 2017 10:34:53 -0700
Message-ID: <CALLGbRJRstmGL-o2ds4SQ5hDNVBcfP23JnRt5qRrVg-ix-8Hiw@mail.gmail.com> (sfid-20170331_193548_381655_563AB014)
Subject: Re: [PATCH] ath6kl: Add __printf verification to ath6kl_dbg
To: Joe Perches <joe@perches.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 31, 2017 at 10:23 AM, Joe Perches <joe@perches.com> wrote:
> On Fri, 2017-03-31 at 10:19 -0700, Steve deRosier wrote:
>> On Thu, Mar 30, 2017 at 3:57 PM, Joe Perches <joe@perches.com> wrote:
>> > Fix fallout too.
> []
>> My only question is why bother doing a format check on something
>> that's going to be compiled out anyway?
>
> To avoid introducing defects when writing new code
> and not using the debugging code path.
>

Fair enough. And I totally agree with the defensive programming here
in that case and feel it's worth the tradeoff (if indeed there really
is any cost, I'm unsure what gcc actually does in this instance).

For sake of discussion though - shouldn't anything not using the debug
code path in this case always be of the form that compiles out? ie
would be empty functions intended here just to make compilation work
and the code that depends on it simpler? Thus, there really should
never be a risk of introducing said defects. If any "real" code were
put in that else clause, that'd be a big red-flag in the review of
said hypothetical patch.

Thanks,
- Steve

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f188.google.com ([209.85.210.188]:38795 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752925AbZGISow (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jul 2009 14:44:52 -0400
Received: by yxe26 with SMTP id 26so560974yxe.33
        for <linux-wireless@vger.kernel.org>; Thu, 09 Jul 2009 11:44:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <6c354a1a0907091136v5619efb5oc6a8a89ec24d4e74@mail.gmail.com>
References: <6c354a1a0906301524m389d49a9sfd812e1ea4740ff5@mail.gmail.com>
	 <20090707030719.GC7199@hash.localnet>
	 <6c354a1a0907072358u7408d865h5b32c587f63f39d@mail.gmail.com>
	 <20090708114252.GG7199@hash.localnet>
	 <6c354a1a0907090942o66c4e1b8ue2c952cf7ed7bf9a@mail.gmail.com>
	 <b6c5339f0907090955v7b99a7ebq26e7cc67ab2493f5@mail.gmail.com>
	 <43e72e890907091002r2dd36efevbfbce06155beb7e5@mail.gmail.com>
	 <b6c5339f0907091048v665dcdf6i659e94de95038856@mail.gmail.com>
	 <43e72e890907091050p7bc08a25s86f9bb7a1c8740aa@mail.gmail.com>
	 <6c354a1a0907091136v5619efb5oc6a8a89ec24d4e74@mail.gmail.com>
Date: Thu, 9 Jul 2009 14:44:51 -0400
Message-ID: <b6c5339f0907091144h39a3df67wa9327157dedb172@mail.gmail.com>
Subject: Re: kernel .30 BROKE ATH5K with my AR5212 atheros.
From: Bob Copeland <me@bobcopeland.com>
To: Jasin Colegrove <j.wholesalesupply@gmail.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 9, 2009 at 2:36 PM, Jasin
Colegrove<j.wholesalesupply@gmail.com> wrote:
> When running git bisect it keeps building 2.6.29-rc kernels. I thought
> v2.6.29 was in the future compared to 2.6.29-rc7 for example.
> running the command git bisect start v2.6.29-rc7 v2.6.29 disagrees
> though and tells me.
>
> It co's a commit somewhere around 2.6.29-rc7 which ultimately was a
> bad commit. Am I misunderstanding how this all works? Sorry to be a
> pain

That confuses everyone the first time.  Basically the way it works
is that a commit that was authored before 2.6.29 will still be checked
since it was only merged in 2.6.29.

         +--- B -- D -+
        /              \
    -- A -- C ---- E -- F -- G

  e.g. in the above graph, imagine E is 2.6.29 and G is 2.6.30.  Commits
B and D were written from a base of 2.6.29-rc6 (say) but merged at time
F between 2.6.29 and 2.6.30.  The bisect will check both parents of F if
it needs to since that's when it actually hit the mainline.

-- 
Bob Copeland %% www.bobcopeland.com

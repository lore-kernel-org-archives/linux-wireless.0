Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qb-out-0506.google.com ([72.14.204.236]:64118 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367AbYHAQLn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Aug 2008 12:11:43 -0400
Received: by qb-out-0506.google.com with SMTP id a16so1106875qbd.17
        for <linux-wireless@vger.kernel.org>; Fri, 01 Aug 2008 09:11:42 -0700 (PDT)
Message-ID: <489335CA.9000204@tuffmail.co.uk> (sfid-20080801_181147_760690_163E5430)
Date: Fri, 01 Aug 2008 17:11:54 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: Bob Copeland <me@bobcopeland.com>, tomasw@gmail.com,
	Dave Young <hidave.darkstar@gmail.com>, stable@kernel.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	linville@tuxdriver.com, Pekka Enberg <penberg@cs.helsinki.fi>,
	ath5k-devel@venema.h4ckr.net, johannes@sipsolutions.net,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: git-describe [Was: ath5k_config_interface deadlock fix]
References: <20080801074014.GA3341@darkstar> <4892C2CA.7010003@gmail.com>		<4892C359.9000304@cs.helsinki.fi>		<20080801011415.ff4821a3.akpm@linux-foundation.org>	<b6c5339f0808010643i58dbb2a7jf459359451061ae4@mail.gmail.com> <4893257C.1020907@gmail.com> <48932A10.8080004@tuffmail.co.uk> <48932AFA.5020903@gmail.com>
In-Reply-To: <48932AFA.5020903@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jiri Slaby wrote:
> Alan Jenkins napsal(a):
>> There must be a better way (for efficient merges, right?).  But all I
>> can think of is comparing the files in question against the diff.  I
>> checked myself and the changes don't appear to have been included in
>> v2.6.26.
>
> Ah, I see. Is this a git-describe bug or my misunderstanding of the tool?

It's not an implementation bug.  It's just very easy to misunderstand.

git-describe only looks _back_ in time to what the current commit is
based on.  In this case the commit was based on v2.6.26-rc8 - but it
_wasn't_ merged into 2.6.26.  It was presumably merged in for
v2.6.27-rc1.  This is a perfectly legal history in GIT.

It's probably most often encountered during git-bisect.  If you bisect
e.g. between v2.6.26 and v.2.6.27-rc1, you're likely to see commits
which were based on v2.6.26-rc8.

If that doesn't help, try finding an introduction to GIT with some good
pictures.  I think it's easier to understand it visually.

Alan

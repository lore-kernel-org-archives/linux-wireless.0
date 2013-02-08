Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:52627 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752933Ab3BHQx4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 11:53:56 -0500
Message-ID: <51152D9E.1040106@openwrt.org> (sfid-20130208_175359_711206_558ADCF5)
Date: Fri, 08 Feb 2013 17:53:50 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Paul Stewart <pstew@google.com>
CC: Sujith Manoharan <sujith@msujith.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Subject: Re: [RFC] ath9k: remove ath9k_rate_control
References: <1360329197-72631-1-git-send-email-nbd@openwrt.org> <20757.1753.863278.858198@gargle.gargle.HOWL> <511508A6.8020104@openwrt.org> <CAMcMvsjE=NNqt_q=vepZbFE8vwLypN2qZwyXg=aCBj3vvYOpMw@mail.gmail.com>
In-Reply-To: <CAMcMvsjE=NNqt_q=vepZbFE8vwLypN2qZwyXg=aCBj3vvYOpMw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-02-08 5:38 PM, Paul Stewart wrote:
> Could you share some of the test results?  I know with ChromeOS when
> we switched to 3.4, the first thing that tipped us off to the fact
> that we had inadvertently switch to minstrel was that our RvR
> throughput values had dropped significantly.  Has anyone done an RvR
> comparison between minstrel and the ath9k internal rate control
> lately?
Are you sure it was minstrel_ht, or could it also have been minstrel
(the legacy version)? I don't have any recent RvR test results, however
on every single link that I tested both rate control modules on (leaving
everything else unchanged), minstrel_ht got slightly better results.
Additionally, I occasionally get asked for help on debugging low
throughput issues, and many of the people asking me have reported that
simply switching to minstrel_ht fixed these issues in their tests.

I would also like to see some real RvR tests comparing both, preferably
before this gets merged, which is why I sent it as RFC.

- Felix

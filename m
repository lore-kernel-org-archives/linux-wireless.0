Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:43917 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752757Ab2FQOgI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Jun 2012 10:36:08 -0400
Message-ID: <4FDDEB50.2040503@openwrt.org> (sfid-20120617_163612_950462_41176129)
Date: Sun, 17 Jun 2012 16:36:00 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Sujith Manoharan <c_manoha@qca.qualcomm.com>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	rodrigue@qca.qualcomm.com
Subject: Re: [PATCH 5/9] ath9k_hw: remove the old ANI implementation
References: <1339766727-61926-1-git-send-email-nbd@openwrt.org> <1339766727-61926-2-git-send-email-nbd@openwrt.org> <1339766727-61926-3-git-send-email-nbd@openwrt.org> <1339766727-61926-4-git-send-email-nbd@openwrt.org> <1339766727-61926-5-git-send-email-nbd@openwrt.org> <20445.11677.349633.688444@gargle.gargle.HOWL>
In-Reply-To: <20445.11677.349633.688444@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-06-17 3:06 AM, Sujith Manoharan wrote:
> Felix Fietkau wrote:
>> It was found to be buggy on a variety of chipsets from AR913x to AR928x.
>> The new version (which was introduced along with AR93xx support) is more
>> reliable in preventing connectivity dropouts and also fixes MIB interrupt
>> storm issues.
> 
> What bugs exactly ? Can you elaborate which cases show improvement ?
> OFDM weak signal detection ?
> CCK weak signal detection ?
> Noise immunity ?
> Firstep_Level ?
I don't know which of those parameters are relevant, I don't have a
reproducible test case myself.
I don't have links to all relevant bug reports anymore, here are a few
that I could find:
https://dev.openwrt.org/ticket/10166
https://dev.openwrt.org/ticket/11442

Some of the discussion is missing in those tickets, as I had some email
exchanges with some of the bug reporters off-list.
What is not very visible in the ticket discussion is that I gave some
test patches to a few users with various parts of Raj's commit reverted
to try to pinpoint the source of the regression, but that didn't work
out, there may be other changes that we haven't found yet that break
old-ANI as well.

> MIB interrupt storms will not be seen because they aren't used at all.
Right, the old implementation depends on MIB interrupt support, the new
one doesn't.

> False positives are an issue with ANI and has this been studied with the
> move to the new algorithm ?
What kind of false positives?

> The new ANI algorithm is designed to take advantage of the HW improvements
> in AR300 and above. Has it been verified that the older HW generation can actually
> conform to the requirements of the new algorithm ?
I did review pretty much all of the code, and the knobs that the ANI
code tweaks really haven't changed much compared to the old
implementation. It's split up into different functions, which makes it a
bit harder to see the similarities.
The main implementation differences that I can find is that the new
implementation does not tweak the AGC parameters anymore (commit log
mentions something about this messing up RIFS Rx) and that the old
implementation tries to tune all available ANI control parameters
individually, whereas the new implementation contains a table that
describes how the parameters are raised/lowered at once (split into OFDM
and CCK).
This simplifies the state machine quite a bit and makes it easier to
make sure that it does not get stuck somewhere.
As for hw specific improvements, old hw does not tweak MRC
enable/disable for CCK, this is dealt with properly in the code.

> If there are bugs or regressions in the existing code in ath9k, we can surely
> fix them. But IMHO, saying 'general stability is improved' is not really a
> justification for code extermination. Why can't we opt for a more evolutionary
> approach ?
Having two similar implementations of the same thing in the code,
partially overlapping, makes the code hard to follow and hard to fix.
Also, as I pointed out, the issue of regressions creeping in because of
complex code is not theoretical, it has already happened, and I believe
it is likely to happen again unless the root cause (spaghetti code) is
fixed.
The main state machine of the new implementation is much easier to
understand and follow than the old one, and I'm confident that it'll be
much easier for us to fix bugs there.

- Felix

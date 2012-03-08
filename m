Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41881 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758252Ab2CHTga convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Mar 2012 14:36:30 -0500
Received: by iagz16 with SMTP id z16so1106126iag.19
        for <linux-wireless@vger.kernel.org>; Thu, 08 Mar 2012 11:36:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B96CD77D9161244899852B5F20DB5B70125BB72@nasanexd02d.na.qualcomm.com>
References: <20120307194001.GA2506@ubuntu-macmini> <20120308174101.GB28133@ubuntu-macmini>
 <CAB=NE6VapPfLjAh5Y+sCA4qA82s9HrQk_Mxr8FpKoCfjudMDig@mail.gmail.com> <4B96CD77D9161244899852B5F20DB5B70125BB72@nasanexd02d.na.qualcomm.com>
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Thu, 8 Mar 2012 11:36:10 -0800
Message-ID: <CAB=NE6U04a0XNrvt6HLCwqbHMtGL8CWh8No_=Bx0mwQZYEgGxQ@mail.gmail.com> (sfid-20120308_203633_962958_F889D86F)
Subject: Re: Problems with regulatory domain support and BCM43224
To: "Quan, David" <dquan@qca.qualcomm.com>
Cc: Seth Forshee <seth.forshee@canonical.com>,
	"Green, Michael" <green@qca.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 8, 2012 at 11:07 AM, Quan, David <dquan@qca.qualcomm.com> wrote:
> 1) Depending on which WW sku number you selected, it may and may not support the DFS channels. So this is not true that we do not support DFS channels in WW mode.

David, sorry I should have clarified, this is not for ath9k. This is
for other drivers which do not have custom regulatory domains nor do
they have any regulatory hint obtainable from their EEPROM. For those
cards that do not have anything like this we make them use the world
regulatory domain by default.

> 2) Today, I do not believe ath9k code supports DFS detection. If that is what you mean. Therefore STA mode will not support DFS detection. However, STA does support DFS channels. DFS channel support vs DFS detection support is two different things. DFS channel support as a slave device, only has to do passive scanning.
>
> Let me know if that answers your questions.

It does, but would like your advice / review on the idea of enabling
DFS channels as passive scan, no-ibss (or any radiation enabled) for
cards that use the static default world regulatory domain in the
kernel. This would not in any way affect ath9k, ath6kl, or any of our
cards, but just help other cards that do not have anything
implemented.

  Luis

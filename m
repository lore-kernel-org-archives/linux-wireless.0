Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:57090 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750724AbZCXEeu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2009 00:34:50 -0400
Message-ID: <49C862D2.7050501@lwfinger.net> (sfid-20090324_053506_978842_78CE41F5)
Date: Mon, 23 Mar 2009 23:34:26 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: johannes@sipsolutions.net, John Linville <linville@tuxdriver.com>
CC: Martin Capitanio <martin@capitanio.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>, herton@mandriva.com.br,
	linux-wireless@vger.kernel.org
Subject: Re: [BUG] rtl8187, cfg80211 - unable to handle kernel NULL pointer
  dereference
References: <1237849455.16745.41.camel@marvin>	 <43e72e890903231610k54ba0f15hf1e3146290c7d67a@mail.gmail.com> <1237859527.5714.60.camel@marvin>
In-Reply-To: <1237859527.5714.60.camel@marvin>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Martin Capitanio wrote:
> Furthermore the current wireless-testing breaks the rtl8187 driver completely.
> If I try to connect to an AP (with or without changing the domain),
> it hard-freezes the kernel without any log entry.

The problem is more general than rtl8187. The system freezes when I try to
connect with rrtl8187 or b43. Using bisection, the bad commit is as follows:

======================================================

commit 59fe3ee33bdb7e8dd0584271382fb94880f68002
Author: Johannes Berg <johannes@sipsolutions.net>
Date:   Sat Mar 21 17:08:43 2009 +0100

    mac80211: remove mixed-cell and userspace MLME code

    Neither can currently be set from userspace, so there's no
    regression potential, and neither will be supported from
    userspace since the new userspace APIs allow the SME, which
    is in userspace, to control all we need.

    Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

============================================================

I have not yet tried to see which hunk or hunks cause the proble, but backing
oout that patch allows the system to work correctly.

Larry



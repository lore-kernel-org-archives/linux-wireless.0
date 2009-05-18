Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.230]:28609 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050AbZERSWj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 May 2009 14:22:39 -0400
Received: by rv-out-0506.google.com with SMTP id f6so957657rvb.5
        for <linux-wireless@vger.kernel.org>; Mon, 18 May 2009 11:22:40 -0700 (PDT)
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 18 May 2009 11:22:17 -0700
Message-ID: <43e72e890905181122w38f83785p2134a5142a9f0905@mail.gmail.com>
Subject: Plan of attack for enhancements for scan while associated
To: Senthil Balasubramanian <senthilkumar@atheros.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Aeolus.Yang@atheros.com, Gaurav.Jauhar@atheros.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Helmut, Senthil has indicated interest in working on this, Johannes
had pointed out you might have some initial work on this already? Can
you post your patch, it might help?

Just so we're clear this would be an enhancement for wext/nl80211
regular scan -- when we're associated we'd do scans by going to a new
channel and then coming back to our operating channel to able to
receive frames. We'd do this for each channel we can scan on until
we're done with all of them.

We could possibly allow for a debugfs parameters to allow users to
tune this to say scan over x channels before going to the operating
channel, as well as change the time between moving to a new channel.
This would probably help mostly with tuning this while debugging or
figuring out ideal default values.

New userspace can simply make use of nl80211 scan on an individual
freq request and figure things out on its own.

  Luis

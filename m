Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54882C4332F
	for <linux-wireless@archiver.kernel.org>; Mon, 13 Nov 2023 09:13:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232633AbjKMJNl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 13 Nov 2023 04:13:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbjKMJNk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Nov 2023 04:13:40 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:242:246e::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6754310D7
        for <linux-wireless@vger.kernel.org>; Mon, 13 Nov 2023 01:13:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=EXqeqztNoPOSRsFn22byyjOUKaf+8T7COF0ijhpGlWo=;
        t=1699866816; x=1701076416; b=vzbTrsgvgClSTzyC3sm/c1rQtMHQSwVZZMWsz7RRWC9dRsv
        G/jatJKFYX2AWdSpGEnphZexY//JZbeTDPB+VzmjLNWuisMijL1AY4Oa5t0a2hmHpmDiZmZMXLqg5
        aU2Irf/vzJCOxRslHQ5dB9ORHeMY4KEgo73I91E+hNIqilA8eXoxXNc4LN1QqjOU91tFwTZWj6vKX
        uXBt54Qfl4zeZRbW6VVGuhATzHscAvhB8kvC7Hf8+nQbZMURXtmjUK0xkuEFSA1UBhj1cCDZeU/Xr
        fwySDPxd+cHpiY85OEvCMfsLpH+uDoIj68svp/0QUklapPHk9rlTo3IZoezc+x3Q==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.97)
        (envelope-from <johannes@sipsolutions.net>)
        id 1r2T0e-00000006bsa-2hId;
        Mon, 13 Nov 2023 10:13:32 +0100
Message-ID: <5a12b8e17b096feae01cf9d25e7d19db04656be3.camel@sipsolutions.net>
Subject: Re: New iwlwifi warning
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Gregory Greenman <gregory.greenman@intel.com>,
        Kalle Valo <kvalo@kernel.org>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>
Date:   Mon, 13 Nov 2023 10:13:31 +0100
In-Reply-To: <CAHk-=wix6kqQ5vHZXjOPpZBfM7mMm9bBZxi2Jh7XnaKCqVf94w@mail.gmail.com>
References: <CAHk-=wix6kqQ5vHZXjOPpZBfM7mMm9bBZxi2Jh7XnaKCqVf94w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sat, 2023-11-11 at 14:34 -0800, Linus Torvalds wrote:
> I only noticed now, because it doesn't cause any issues, but that may
> be because this only happens on my desktop, and I don't actually use
> the wireless there...
>=20

For the record, it's just for debug prints. Not sure how the ordering
issue slipped through though.

I've converted some other checks we had to kunit tests, maybe we should
convert this one too, it's not critical and kunit tests can even run
without loading the hardware, unlike this.

johannes

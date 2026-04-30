Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7ECC27A476;
	Thu, 30 Apr 2026 14:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777558360; cv=none; b=oGSJ0GkFbtjlTgLHRM+Np7oKrvTAryBqjs5XmZIq7pF0VMqHEoa+brErQ/+nGnvMVqPcRUy5j1qNbiU5ie0N71gG4P/kNnAx8tfFGZB2t6yQz8lfXnolAR4W3wEeUN/rtXHyee4oTCTABAdYPAYsFagvqnsNLxUPGkH1oY0JfCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777558360; c=relaxed/simple;
	bh=q6wE4e/BYHPWr7674ATth+PYYTMBxroeOuP+HW6wfh4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UiuM8VT7dIluc59K9DdzJK/H6b195EJzu/IjV3agA4vxnzQX++5DD9U99uSQldY5kt/MqJMSm3Wb2ou1h2TJvcI8/5xrNGMsLZVTpyRgXGdguQ51lMlc0Ei2BAaclW9xZx30aQW3FtIwMTYEY8nCnaOaR0Q3i3OOx4bzb5/9lM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eZhRiFTQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eZhRiFTQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27BE9C2BCB3;
	Thu, 30 Apr 2026 14:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777558360;
	bh=q6wE4e/BYHPWr7674ATth+PYYTMBxroeOuP+HW6wfh4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=eZhRiFTQVwHf2/XJe2Y9Zic7zOef4BMwtOA8pC/lcPxfhCPXu1X1YAq2jhtaxYuNb
	 VUFO6QikbhgMMKy179Khhe2rwGBiVE6qtBewEszF0hnyQly4Qbnqlqrtf7mGbkicZg
	 5wpRt6tXdQLFpezpiVrVZyfu8z1tObEIXuPhr+rpuRz9JX2biP60naVWB2A4HyBDb5
	 JyDn4nfCgx8go1LvCjBw0h8rtx9jUkRItoqFc1aUOL5M4BFaEcRu1IXDTF8t5WEirU
	 0h6p9SCGsveUIs1ofrrnCe88A2BoVrod7E2y68TBcHntCsrTF/Is/FRnmAbys0M5dQ
	 mxj5MK9hoCmvw==
Date: Thu, 30 Apr 2026 07:12:39 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [GIT PULL] wireless-2026-04-30
Message-ID: <20260430071239.36b0e5f0@kernel.org>
In-Reply-To: <20260430111831.219242-6-johannes@sipsolutions.net>
References: <20260430111831.219242-6-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 30 Apr 2026 13:17:52 +0200 Johannes Berg wrote:
> So the LLM floodgates are starting to open ;-) But I'm somewhat
> happy that so far we haven't gotten any really critical reports.
> Here's a couple of first fixes though.
> 
> Please pull and let us know if there's any problem.

Looks like this breaks kunit:

ok 70 mac80211-tpe
    KTAP version 1
    # Subtest: mac80211-mlme-chan-mode
    # module: mac80211_tests
    1..1
        KTAP version 1
        # Subtest: test_determine_chan_mode
        ok 1 Normal case, EHT is working
        ok 2 Requiring EHT support is fine
        ok 3 Lowering the mode limits us
kunit: required basic rate or BSS membership selectors not supported or disabled, rejecting connection
        ok 4 Requesting a basic rate/selector that we do not support
        ok 5 As before, but userspace says it is taking care of it
    # test_determine_chan_mode: ASSERTION FAILED at net/mac80211/tests/chan-mode.c:258
    Expected conn.mode == params->expected_mode, but
        conn.mode == 5 (0x5)
        params->expected_mode == 1 (0x1)
        not ok 6 Masking out a supported rate in HT capabilities
kunit: Missing mandatory rates for 4 Nss, rx 0, tx 2 oper 2, disable VHT
kunit: required MCSes not supported, disabling VHT
        ok 7 Masking out a RX rate in VHT capabilities
kunit: Missing mandatory rates for 4 Nss, rx 2, tx 0 oper 2, disable VHT
kunit: required MCSes not supported, disabling VHT
        ok 8 Masking out a TX rate in VHT capabilities
kunit: Missing mandatory rates for 5 Nss, rx 0, tx 0 oper 2, disable VHT
kunit: required MCSes not supported, disabling VHT
        ok 9 AP has higher VHT requirement than client
        ok 10 all zero VHT basic rates are ignored (many APs broken)
kunit: Invalid rates for 3 Nss, rx 3, tx 3 oper 0, disable HE
kunit: required MCSes not supported, disabling HE
        ok 11 AP requires 3 HE streams but client only has two
        ok 12 all zero HE basic rates are ignored (iPhone workaround)
kunit: required MCSes not supported, disabling EHT
        ok 13 AP requires too many RX streams with EHT MCS 7
kunit: required MCSes not supported, disabling EHT
        ok 14 AP requires too many TX streams with EHT MCS 7
kunit: required MCSes not supported, disabling EHT
kunit: required basic rate or BSS membership selectors not supported or disabled, rejecting connection
        ok 15 AP requires too many RX streams with EHT MCS 7 and EHT is required
kunit: regulatory prevented using AP config, downgraded
kunit: required bandwidth not supported, disabling EHT
        ok 16 80 MHz EHT is downgraded to 40 MHz HE due to puncturing
    # test_determine_chan_mode: pass:15 fail:1 skip:0 total:16
    not ok 1 test_determine_chan_mode
# Totals: pass:15 fail:1 skip:0 total:16

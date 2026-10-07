Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ABE84908C4;
	Wed,  7 Oct 2026 10:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791369138; cv=none; b=jX7UqnH5UilP3qvS/G64c3DV0x3Gd3XvBKeJZ+hMHWbYQtFGO5hFEbmB5A25PK/lU1uUHBfWvKaVmmMxZ/Dk5JEG1BCYeWHstFwcql9v5M+sA2EoW3BClVDL2mPcMqsnKe+YRaMSdZn7DD4f39yhgsLGs65ICTvmBMlLloLfVQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791369138; c=relaxed/simple;
	bh=wEDfwQuRZU22JgY3itKQBY7RJx+iabdOhOhUmkJrff0=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=srKGSA9STqYTGH1ZtRtSNBThGwLVs34eG/TpR7lceD6DZ/ktwpUyvbxSgs/uDLH+6oFsGwirDuif6CZpibyt+s5WlDgflYEd5J52uxAvXk4SfwBJIis62/fkbEccS7XRIyjGZqPUAKi8FeColJTadB3bbYxfTvMt1s39l/vsB1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HYYgyUHq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HYYgyUHq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3DF91F0089B;
	Wed,  7 Oct 2026 10:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791369110;
	bh=POb+8CrETllSqt/7hwcYZ6rZzQWcCujqGM6EVPxZteI=;
	h=Date:From:To:Cc:Subject;
	b=HYYgyUHq+u5mN8rMYgE2QxKzv8p9gy1pK66pwq0FW9TQwX30baHyCcEJDeVmALypi
	 h3y19dknGVe71n9fGOtdkeO267wDV1U2pDA8EQhUS/XbuvIqDi1QQihL13h/Y2FLUx
	 rGT4Wooong3eRZ+CGAMkllJ034TJE1ASXfPVnAOqYnm/OOcFCoTDOBRwVLzxbagt1k
	 WhV6kiBQY6N5WveEmswdy1tvXic62MmBjJvQDgeYaIMKdfo1cu2/S6W0XylgZ1FgJ6
	 CBg+ak5keFYFcHbfaRpk95RiIue3ZabIeTpy+g29FV7PaA+umwp4g3c93tv3r0ElMm
	 BZS0Vpmypbv5w==
Received: by finisterre.sirena.org.uk (Postfix, from userid 1000)
	id 820D31AC57CE; Wed, 07 Oct 2026 11:31:47 +0100 (BST)
Date: Wed, 7 Oct 2026 12:31:47 +0200
From: Mark Brown <broonie@kernel.org>
To: Johannes Berg <johannes@sipsolutions.net>,
	Wireless <linux-wireless@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Subject: Missing signoff in the wireless tree
Message-ID: <asYfk8onC1sBo23Y@sirena.co.uk>
Mail-Followup-To: Johannes Berg <johannes@sipsolutions.net>,
	Wireless <linux-wireless@vger.kernel.org>,
	linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="t2wpU7BktQyrAVcl"
Content-Disposition: inline


--t2wpU7BktQyrAVcl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Commit

  6d41af9b469a3 ("wifi: mt76: mt7996: fix uninitialized buf read in mt7996_variant_fem_init()")

is missing a Signed-off-by from its committer

--t2wpU7BktQyrAVcl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQReagvpf3TrrA7BoYYv73Ows9A4iQUCasYfjwAKCRAv73Ows9A4
ifepAQCz6kkquo7d/Z9r2FflnhxZaSxqxnqFw/QQ0L3A8HiB8wD/STcqxJ984SHF
/pCsR2hmp+ZOU/5VigVVf1eMC9NU8wc=
=txf2
-----END PGP SIGNATURE-----

--t2wpU7BktQyrAVcl--

Received: from smtp-8fae.mail.infomaniak.ch (smtp-8fae.mail.infomaniak.ch [83.166.143.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73C373BD22C
	for <linux-wireless@vger.kernel.org>; Thu, 16 Apr 2026 12:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.166.143.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776342324; cv=none; b=SoF9SuQEt5EXtisZl5He5Ijoyir9XZsirCut7CIV7YxsLobsjlXfIMcKc1Mtz6GgMB9LCl3/FqaYtgQzbXIJ9nGxnr1+c4j66Ir86+cuYsO6Cs41uOTqicMwsnN8T47ggDvJDxecsXO9hmTFVXXmcU5N3FS/vCqwyZ/VQwEgcc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776342324; c=relaxed/simple;
	bh=yAEsl8+RbFJnU2k6hmzmFfie6p2P5TOTFpnJB3ufL4U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dhuQh3xVz5mdJVURl+fQhgPexmgBRanjDMFrwwTs25EtYSwR9KTqPwXuuLOpE0YsHxfLWcEM1czBVMz0eHes0vapKOLkTj8Og9NQXd0/r5p1KPdo9YX9YhQ9EacsbtzH8IsLboyCH6YEgRsSzvmfBxqGHppcKJ7LeqPd8xc3low=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=eskapa.be; spf=pass smtp.mailfrom=eskapa.be; dkim=pass (2048-bit key) header.d=eskapa.be header.i=@eskapa.be header.b=qQEY+OoA; arc=none smtp.client-ip=83.166.143.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=eskapa.be
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=eskapa.be
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=eskapa.be header.i=@eskapa.be header.b="qQEY+OoA"
Received: from smtp-3-0000.mail.infomaniak.ch (unknown [IPv6:2001:1600:4:17::246b])
	by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4fxGV52rZlz3tl;
	Thu, 16 Apr 2026 13:47:57 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=eskapa.be;
	s=20230820; t=1776340077;
	bh=UqyHqwAOAFOnl1e5d1PFPt/3aC/miMWfLDlF296RD0w=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=qQEY+OoA7vTnb45uPzcPQKc1Bi8ppUzXTxA5q8ojHIhNsiVhyRSh5lddWbsWfhcTQ
	 QkFRZgifRzhMwuzUaGYBtGk6j/82lmlPmF7eN3HZSGW8dAqsoRaAZnivS8qLb40mG4
	 vCAeq48U003Csm17LntKsggHsNFSC4Umlnp4VByoSrInsMzRi1vRrrsHLsEBZyGAtp
	 Z/rmY3BeJVznST6O46AdeM9UQ/SL17yezwziQyJA0NcuKz5AAq8w6/GEe9MLxbcjOE
	 dvWVizApOZ9pph15UEYrOXD1WAMn/ldLmA8jM+lqeUN9cOp6JZ0j795Gxdlrz/WnLt
	 8somhAAYNTWCQ==
Received: from unknown by smtp-3-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4fxGV46qLkzkkW;
	Thu, 16 Apr 2026 13:47:56 +0200 (CEST)
Message-ID: <beee4be9-2bfc-4c38-ad1b-13ecc7d90aa3@eskapa.be>
Date: Thu, 16 Apr 2026 13:47:56 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Wi-Fi speeds degrade from 600Mps to 30Mps while using WPA2
 security, but not on open network, shortly after ISP firmware upgrade.
To: Benson Bear <benson.bear@gmail.com>
Cc: linux-wireless@vger.kernel.org
References: <CACM6vn7QGKQcR5Rs=wmzNA-SgMDZX4Hw=UiPQHfYkWgLURcbAA@mail.gmail.com>
 <b1a7678d-8e87-444e-b38a-bb7aedcd4f30@eskapa.be>
 <CACM6vn6UXfSXw2WpYvzF+ODPGHw-LtsBMgtvc6n7s9iF9eaS6Q@mail.gmail.com>
From: Pablo MARTIN-GOMEZ <pablomg@eskapa.be>
Content-Language: en-US
In-Reply-To: <CACM6vn6UXfSXw2WpYvzF+ODPGHw-LtsBMgtvc6n7s9iF9eaS6Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Infomaniak-Routing: alpha

On 16/04/2026 13:03, Benson Bear wrote:
> Hi Pablo, thanks for your really prompt reply.   And sorry
> for the spelling error in the Subject header ("Mps" for "Mbps")
> and the horrid line formatting.  (Not used to using short lines
> although that is what I grew up on).
> 
> And... you got it!   The MFP flag is lacking, and googling
> showed me that instead of  messing with wpa_supplicant, I
> can apparently do the same with nmcli:
> 
> nmcli connection modify NAME 802-11-wireless-security.pmf disable
Oh yeah, I didn't check nmcli documentation thoroughly enough to find
that option. Quite easier to implement than going the raw wpa_supplicant
way.
> 
> I tried that and it worked!   Internet speed test back to 600Mbps!
> What a relief!  Thank you very much!
> 
> I will try other testing with just pure Wi-Fi and with all machines
> after I get some sleep.
> 
> Can you tell me why this is likely to have happened?  Surely
> one side or the other is misconfigured?  This misunderstanding
> between them should not be possible within a good specification,
> right?
Given that your client does not have the MFP flag and you can connect
without PMF, that means that your AP advertise MFP Capable (and so is
your client when it is not disabled), and following the association +
4-way handshake, the AP believes it has correctly negotiated MFP but not
your client, so the AP is sending the client encrypted action framed
that are dropped by the client and the client is sending non-encrypted
action frames that are refused by the AP. The easiest way to debug this
would be to capture over the air the auth + assoc + 4-way handshake +
action frame and provide the SSID + the PSK to be able to decrypt
everything and understand who is in the wrong. If it's an issue on the
client side, it is most probably an issue in wpa_supplicant and not in
the kernel.
> 
> (Sadly I think I might have an idea -- it's partly my fault.   The
> mac80211 module was disabling all HT and above because it
> felt it could not meet the BCS criteria laid down by the AP.
> Many people have thought these criteria were way too onerous.
> So I first had very low speeds because of that.  No HT even.
> I applied a patch to the module that ignored these requirements
> and got back to a high connection speed, and HE or VHT
> enabled, and got back a little of the lost speed.   Clearly very
> kludgy but seems a legitimate response to what the patch
> author called "aggressive basic MCS rates". But it may
> have opened up the room for misunderstandings.  I have my
> speed back in practice, but I wonder what the "correct" way
> of fixing this would be -- without the kludgy module patch).
> 
> Thanks again!
> 


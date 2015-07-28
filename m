Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f196.google.com ([209.85.213.196]:36366 "EHLO
	mail-ig0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878AbbG1Rl6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jul 2015 13:41:58 -0400
MIME-Version: 1.0
In-Reply-To: <3945775.m5HblJPgiO@tauon.atsec.com>
References: <1436946847-10909-1-git-send-email-miaoqing@qca.qualcomm.com>
	<a8b787bd17d94e8899bf1be6131165b2@NASANEXM01E.na.qualcomm.com>
	<55B60BC9.8040800@rempel-privat.de>
	<3945775.m5HblJPgiO@tauon.atsec.com>
Date: Tue, 28 Jul 2015 13:41:57 -0400
Message-ID: <CACXcFmnUcf66+X967JQL9mGrpa6ZYOqz99oK6JV8nFzABn=NZA@mail.gmail.com> (sfid-20150728_194214_542104_C8DD7699)
Subject: Re: [PATCH 2/2] ath9k: export HW random number generator
From: Sandy Harris <sandyinchina@gmail.com>
To: Stephan Mueller <smueller@chronox.de>
Cc: Oleksij Rempel <linux@rempel-privat.de>,
	"Pan, Miaoqing" <miaoqing@qti.qualcomm.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Theodore Ts'o" <tytso@mit.edu>, linux-crypto@vger.kernel.org,
	nhorman@tuxdriver.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 27, 2015 at 7:01 AM, Stephan Mueller <smueller@chronox.de> wrote:

> This one does not look good for a claim that the RNG produces white noise. An
> RNG that is wired up to /dev/hwrng should produce white noise. Either by
> having an appropriate noise source or by conditioning the output of the noise
> source.

Yes.

> When conditioning the output, you have to be careful about the entropy claim.

A very good analysis of how to deal with this is in Denker's Turbid paper:
http://www.av8n.com/turbid/

In particular, see section 4.2 on Saturation

> However, the hwrandom framework does not provide any conditioning logic.

At first sight, this sounds like a blunder to me, but I have not
looked at hwrandom at all. Is there a rationale?

For example, not building conditioning into that driver would make
perfect sense if the output were just being fed into the random(4)
which does plenty of mixing. The only problem then would be to make
sure of giving random(4) reasonable entropy estimates.

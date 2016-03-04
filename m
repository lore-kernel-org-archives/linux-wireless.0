Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from canardo.mork.no ([148.122.252.1]:36353 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759582AbcCDUWI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Mar 2016 15:22:08 -0500
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: "Coelho\, Luciano" <luciano.coelho@intel.com>
Cc: "Grumbach\, Emmanuel" <emmanuel.grumbach@intel.com>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Ivgi\, Chaya Rachel" <chaya.rachel.ivgi@intel.com>
Subject: Re: [PATCH 02/43] iwlwifi: mvm: add registration to thermal zone
References: <0BA3FCBA62E2DC44AF3030971E174FB32EA50146@hasmsx107.ger.corp.intel.com>
	<1456905404-14435-2-git-send-email-emmanuel.grumbach@intel.com>
	<877fhi9jes.fsf@nemi.mork.no> <8737s69irg.fsf@nemi.mork.no>
	<1457121461.28365.175.camel@intel.com>
Date: Fri, 04 Mar 2016 21:22:00 +0100
In-Reply-To: <1457121461.28365.175.camel@intel.com> (Luciano Coelho's message
	of "Fri, 4 Mar 2016 19:57:42 +0000")
Message-ID: <87y49y8047.fsf@nemi.mork.no> (sfid-20160304_212230_188812_1464DAA1)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Coelho, Luciano" <luciano.coelho@intel.com> writes:
> On Fri, 2016-03-04 at 19:53 +0100, Bjørn Mork wrote:
>
>> Still think it's unwise to leave ERR_PTR's around though.
>
> The main point is that we don't want to fail the entire driver loading
> if the thermal zone (or cooling device) registration fails.  We have a
> fallback for that, which is what was used before this new
> implementation (namely, the thermal throttling code in the driver).

Sure.  I just think it is cleaner to replace the ERR_PTR with NULL
before returning.  Minor nit of course.  I wouldn't have bothered with
it if I hadn't wrongly thought that it would crash,



Bjørn

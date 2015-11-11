Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0006.hostedemail.com ([216.40.44.6]:42605 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752188AbbKKOpT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Nov 2015 09:45:19 -0500
Date: Wed, 11 Nov 2015 09:45:16 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Luca Coelho <luca@coelho.fi>, linux-wireless@vger.kernel.org,
	Jason Baron <jbaron@akamai.com>,
	Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC v2 3/4] mac80211: use static keys for hw flags
Message-ID: <20151111094516.07d5d1d5@gandalf.local.home> (sfid-20151111_154523_285282_5A490E4E)
In-Reply-To: <1447252142.2276.19.camel@sipsolutions.net>
References: <1447145549-27376-1-git-send-email-johannes@sipsolutions.net>
	<1447145549-27376-4-git-send-email-johannes@sipsolutions.net>
	<1447201345.2475.15.camel@coelho.fi>
	<1447227472.2276.7.camel@sipsolutions.net>
	<20151111083430.1e77c329@gandalf.local.home>
	<1447249156.2276.17.camel@sipsolutions.net>
	<20151111091859.55f6a4fd@gandalf.local.home>
	<1447252142.2276.19.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 11 Nov 2015 15:29:02 +0100
Johannes Berg <johannes@sipsolutions.net> wrote:


config MY_DRIVER_1
	SELECT SET_FLAG

config MY_DRIVER_2
	SELECT SET_FLAG

[...]


config FLAG_ALL_SET
  default y
  depends on MY_DRIVER_1 && !MY_DRIVER_2 && ... && MY_DRIVER_N


> Right. Basically it'd be one of three options:
>  * all compiled drivers want the flag set:
>    use a static key to make the fast case "flag set"

#if defined(CONFIG_SET_FLAG) && defined(CONFIG_FLAG_ALL_SET)

>  * no compiled driver wants the flag set:
>    use a static key to make the fast case "flag unset"

#ifndef CONFIG_SET_FLAG

>  * different drivers are compiled:
>    don't use a static key since we don't know which one will get used

#if defined(CONFIG_FLAG_SET) && !defined(CONFIG_FLAGS_ALL_SET)

-- Steve


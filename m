Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.178]:6855 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755180AbYF3NbY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jun 2008 09:31:24 -0400
Received: by py-out-1112.google.com with SMTP id p76so279842pyb.10
        for <linux-wireless@vger.kernel.org>; Mon, 30 Jun 2008 06:31:22 -0700 (PDT)
Message-ID: <1ba2fa240806300631s71ce6b25l4799baa0fa5958ba@mail.gmail.com> (sfid-20080630_153133_131579_C7F509A6)
Date: Mon, 30 Jun 2008 16:31:21 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 1/1 V2] cfg80211: adding NONE regdomain
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>, linville@tuxdriver.com,
	yi.zhu@intel.com, linux-wireless@vger.kernel.org,
	"Ester Kummer" <ester.kummer@intel.com>
In-Reply-To: <1214825747.5507.47.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1214732604-4573-1-git-send-email-tomas.winkler@intel.com>
	 <43e72e890806300118me4b20bv2b91f30f91eaa7f3@mail.gmail.com>
	 <1ba2fa240806300152o6d5f7deby6d00a4421138177c@mail.gmail.com>
	 <43e72e890806300159j6c98ef9dpeac61d5aeca19f0e@mail.gmail.com>
	 <1214817730.5507.27.camel@johannes.berg>
	 <1ba2fa240806300425i609ababfj22a76718d3857f85@mail.gmail.com>
	 <1214825747.5507.47.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 30, 2008 at 2:35 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2008-06-30 at 14:25 +0300, Tomas Winkler wrote:
>
>> The idea was ask troubled user to make change in modprobe.conf and not
>> changing the code.
>
> Yeah but IMHO you're solving the wrong problem. If we want any
> credibility we shouldn't allow users to ignore any regdom that easily,
> and this is system-wide. Also, iwlwifi partly caused this problem in the
> first place by printing out eeprom channels rather than having users use
> "iwlist wlan0 channel" to see which channels are usable. Or even iw,
> which shows you which are disabled.

Unfortunately iwlist channel gives very little information about
channels and iw is not distributed by any distro as far as I know.

Here is little patch to help iw be more useful.

--- a/iw.c
+++ b/iw.c
@@ -95,7 +95,7 @@ static void usage(char *argv0)
        fprintf(stderr, "Usage: %1$s dev <phydev> <OBJECT> <COMMAND> [OPTIONS]"
                        "\n     %1$s dev <phydev> info\n"
                        "\n"
-                       "where OBJECT := { interface | station | mpath }\n"
+                       "where OBJECT := { interface | station | mpath
| info }\n"
                        "and COMMAND := { add | del | set | get | dump }\n",
                        argv0);
 }


Tomas

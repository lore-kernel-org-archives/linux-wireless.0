Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753805AbdKJU2o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 10 Nov 2017 15:28:44 -0500
MIME-Version: 1.0
In-Reply-To: <20171110202601.GR22894@wotan.suse.de>
References: <1482598381-16513-1-git-send-email-pali.rohar@gmail.com>
 <1510270708-14377-1-git-send-email-pali.rohar@gmail.com> <1510270708-14377-6-git-send-email-pali.rohar@gmail.com>
 <20171110202601.GR22894@wotan.suse.de>
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Date: Fri, 10 Nov 2017 12:28:22 -0800
Message-ID: <CAB=NE6WZYcjZthaW4crivbQi6+vgUmgvHQwJZUuAYFtJpZwX7Q@mail.gmail.com> (sfid-20171110_212904_155753_042151ED)
Subject: Re: [PATCH v2 5/6] firmware: Add request_firmware_prefer_user() function
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali.rohar@gmail.com>
Cc: Ming Lei <ming.lei@canonical.com>,
        "Luis R. Rodriguez" <mcgrof@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        David Gnedt <david.gnedt@davizone.at>,
        Michal Kazior <michal.kazior@tieto.com>,
        Daniel Wagner <wagi@monom.org>,
        Tony Lindgren <tony@atomide.com>,
        Sebastian Reichel <sre@kernel.org>,
        Pavel Machek <pavel@ucw.cz>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Grazvydas Ignotas <notasas@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 10, 2017 at 12:26 PM, Luis R. Rodriguez <mcgrof@kernel.org> wrote:
> even if you *leave* the flag in place and a driver required
> this, but the kernel was compiled without CONFIG_FW_LOADER_USER_HELPER then
> calling fw_load_from_user_helper would just already return -ENOENT, as such it
> would in turn fallback to direct fs loading so the #ifef'ery seems to be not
> needed.

> The commit log in no way documents any of the justifications for further
> extending use of the usermode helper.

Also, any new functionality introduced should have a respective test
case in tools/testing/selftests/firmware/ and lib/test_firmware.c, as
well as extending existing documentation on
Documentation/driver-api/firmware/.

  Luis

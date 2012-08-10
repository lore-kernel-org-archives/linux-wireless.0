Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from quad.pendre.co.uk ([195.137.4.79]:47203 "EHLO quad.pendre.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751298Ab2HJMkg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Aug 2012 08:40:36 -0400
Message-ID: <50250142.4010603@elrepo.org> (sfid-20120810_144040_215417_D0FA5BFA)
Date: Fri, 10 Aug 2012 13:40:34 +0100
From: Phil Perry <phil@elrepo.org>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@frijolero.org>
CC: lf_driver_backport@lists.linux-foundation.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] compat: fix KLIB_BUILD
References: <502407FC.70704@elrepo.org> <CAB=NE6UYFx17AthecDk5jdgBVP6b5kju5c+XdkT-FviGWfHW1Q@mail.gmail.com>
In-Reply-To: <CAB=NE6UYFx17AthecDk5jdgBVP6b5kju5c+XdkT-FviGWfHW1Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/08/12 00:00, Luis R. Rodriguez wrote:
> On Thu, Aug 9, 2012 at 11:57 AM, Phil Perry<phil@elrepo.org>  wrote:
>> This patch fixes a small typo in ${KLIB_BUILD}
>>
>> Signed-off-by: Philip J Perry<phil@elrepo.org>
>
> I had issues applying this, I blame the
> lf_driver_backport@lists.linux-foundation.org mailing list as we had
> determine a while ago that it had issues. Phil, in the meantime can
> you resend to linux-wireless ?
>
> David,
>
> is there a chance to create a backports@vger.kernel.org mailing list
> for backporting effort?
>
>    Luis
>

Resending to include linux-wireless@vger.kernel.org

This patch fixes a small typo in ${KLIB_BUILD}

Signed-off-by: Philip J Perry <phil@elrepo.org>
---
  scripts/gen-compat-config.sh | 2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/gen-compat-config.sh b/scripts/gen-compat-config.sh
index 3eba34e..cdb1584 100755
--- a/scripts/gen-compat-config.sh
+++ b/scripts/gen-compat-config.sh
@@ -48,7 +48,7 @@ done
  # The RHEL checks seem to annotate the existance of RHEL minor versions.
  RHEL_MAJOR=$(grep ^RHEL_MAJOR ${KLIB_BUILD}/Makefile | sed -n 's/.*= 
*\(.*\)/\1/p')
  if [[ ! -z ${RHEL_MAJOR} ]]; then
-	RHEL_MINOR=$(grep ^RHEL_MINOR $(KLIB_BUILD)/Makefile | sed -n 's/.*= 
*\(.*\)/\1/p')
+	RHEL_MINOR=$(grep ^RHEL_MINOR ${KLIB_BUILD}/Makefile | sed -n 's/.*= 
*\(.*\)/\1/p')
  	for i in $(seq 0 ${RHEL_MINOR}); do
  		eval CONFIG_COMPAT_${RHEL_MAJOR}_${i}=y
  		echo "export CONFIG_COMPAT_${RHEL_MAJOR}_${i}=y"
-- 
1.7.11.1

